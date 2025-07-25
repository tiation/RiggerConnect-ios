//
//  NetworkLayer.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Network Layer

public final class NetworkLayer {
    public static let shared = NetworkLayer()
    
    private let session: URLSession
    private let tokenManager = TokenManager.shared
    private let environmentConfig = EnvironmentConfig.shared
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = environmentConfig.timeout
        configuration.timeoutIntervalForResource = environmentConfig.timeout * 2
        configuration.waitsForConnectivity = true
        
        self.session = URLSession(configuration: configuration)
        
        // Configure JSON decoder for API dates
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        // Configure JSON encoder
        self.encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - Generic Request Method
    
    public func request<T: Codable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        requiresAuth: Bool = true
    ) async throws -> T {
        
        let request = try await buildRequest(for: endpoint, requiresAuth: requiresAuth)
        
        do {
            return try await performRequest(request: request, responseType: responseType)
        } catch NetworkError.unauthorized {
            if requiresAuth && tokenManager.canRefreshToken {
                // Attempt token refresh
                try await refreshToken()
                let refreshedRequest = try await buildRequest(for: endpoint, requiresAuth: requiresAuth)
                return try await performRequest(request: refreshedRequest, responseType: responseType)
            } else {
                throw NetworkError.unauthorized
            }
        }
    }
    
    // MARK: - Request Building
    
    private func buildRequest(for endpoint: APIEndpoint, requiresAuth: Bool) async throws -> URLRequest {
        let url = environmentConfig.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add authentication header if required
        if requiresAuth {
            guard let token = tokenManager.accessToken else {
                throw NetworkError.noAuthToken
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add request body for POST/PUT/PATCH requests
        if let body = endpoint.body {
            request.httpBody = try encoder.encode(body)
        }
        
        // Add query parameters
        if !endpoint.queryParameters.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = endpoint.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components?.url
        }
        
        // Debug logging
        if environmentConfig.isDebugLoggingEnabled {
            logRequest(request)
        }
        
        return request
    }
    
    // MARK: - Request Execution
    
    private func performRequest<T: Codable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        
        let (data, response) = try await session.data(for: request)
        
        // Debug logging
        if environmentConfig.isDebugLoggingEnabled {
            logResponse(data: data, response: response)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Handle different HTTP status codes
        switch httpResponse.statusCode {
        case 200...299:
            // Success - decode the response
            do {
                // Handle API response wrapper
                if let apiResponse = try? decoder.decode(APIResponse<T>.self, from: data) {
                    if apiResponse.success, let data = apiResponse.data {
                        return data
                    } else if let error = apiResponse.error {
                        throw NetworkError.apiError(error)
                    } else {
                        throw NetworkError.invalidResponse
                    }
                } else {
                    // Direct response without wrapper
                    return try decoder.decode(T.self, from: data)
                }
            } catch let decodingError as DecodingError {
                throw NetworkError.decodingError(decodingError)
            }
            
        case 401:
            throw NetworkError.unauthorized
            
        case 403:
            throw NetworkError.forbidden
            
        case 404:
            throw NetworkError.notFound
            
        case 422:
            // Validation error
            if let apiResponse = try? decoder.decode(APIResponse<T>.self, from: data),
               let error = apiResponse.error {
                throw NetworkError.validationError(error)
            } else {
                throw NetworkError.validationError(APIError(code: "VALIDATION_ERROR", message: "Validation failed"))
            }
            
        case 429:
            throw NetworkError.rateLimited
            
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
            
        default:
            throw NetworkError.httpError(httpResponse.statusCode)
        }
    }
    
    // MARK: - Token Refresh
    
    private func refreshToken() async throws {
        guard let refreshToken = tokenManager.refreshToken else {
            throw NetworkError.noRefreshToken
        }
        
        let endpoint = APIEndpoint.refreshToken
        var request = URLRequest(url: environmentConfig.baseURL.appendingPathComponent(endpoint.path))
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            tokenManager.clearSession()
            throw NetworkError.tokenRefreshFailed
        }
        
        let authResponse = try decoder.decode(APIResponse<AuthResponse>.self, from: data)
        
        guard authResponse.success, let authData = authResponse.data else {
            tokenManager.clearSession()
            throw NetworkError.tokenRefreshFailed
        }
        
        tokenManager.updateTokens(accessToken: authData.token)
    }
    
    // MARK: - Convenience Methods
    
    public func get<T: Codable>(
        path: String,
        queryParameters: [String: String] = [:],
        responseType: T.Type,
        requiresAuth: Bool = true
    ) async throws -> T {
        let endpoint = APIEndpoint.custom(
            path: path,
            method: .GET,
            queryParameters: queryParameters
        )
        return try await request(endpoint: endpoint, responseType: responseType, requiresAuth: requiresAuth)
    }
    
    public func post<T: Codable, U: Codable>(
        path: String,
        body: U? = nil,
        responseType: T.Type,
        requiresAuth: Bool = true
    ) async throws -> T {
        let endpoint = APIEndpoint.custom(
            path: path,
            method: .POST,
            body: body as? AnyEncodable
        )
        return try await request(endpoint: endpoint, responseType: responseType, requiresAuth: requiresAuth)
    }
    
    public func put<T: Codable, U: Codable>(
        path: String,
        body: U? = nil,
        responseType: T.Type,
        requiresAuth: Bool = true
    ) async throws -> T {
        let endpoint = APIEndpoint.custom(
            path: path,
            method: .PUT,
            body: body as? AnyEncodable
        )
        return try await request(endpoint: endpoint, responseType: responseType, requiresAuth: requiresAuth)
    }
    
    public func delete<T: Codable>(
        path: String,
        responseType: T.Type,
        requiresAuth: Bool = true
    ) async throws -> T {
        let endpoint = APIEndpoint.custom(
            path: path,
            method: .DELETE
        )
        return try await request(endpoint: endpoint, responseType: responseType, requiresAuth: requiresAuth)
    }
    
    // MARK: - Debug Logging
    
    private func logRequest(_ request: URLRequest) {
        print("🌐 REQUEST:")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        
        print("---")
    }
    
    private func logResponse(data: Data, response: URLResponse) {
        print("📡 RESPONSE:")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Body: \(responseString)")
        }
        
        print("---")
    }
}

// MARK: - API Endpoint

public struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let queryParameters: [String: String]
    let body: AnyEncodable?
    
    public init(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: String] = [:],
        body: AnyEncodable? = nil
    ) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.body = body
    }
}

// MARK: - Predefined Endpoints

public extension APIEndpoint {
    // Authentication
    static let login = APIEndpoint(path: "auth/login", method: .POST)
    static let register = APIEndpoint(path: "auth/register", method: .POST)
    static let refreshToken = APIEndpoint(path: "auth/refresh", method: .POST)
    
    // Users
    static let getUserProfile = APIEndpoint(path: "users/profile", method: .GET)
    static let updateUserProfile = APIEndpoint(path: "users/profile", method: .PUT)
    
    // Jobs
    static let getJobs = APIEndpoint(path: "jobs", method: .GET)
    static let createJob = APIEndpoint(path: "jobs", method: .POST)
    static func getJob(id: String) -> APIEndpoint {
        return APIEndpoint(path: "jobs/\(id)", method: .GET)
    }
    static func applyToJob(id: String) -> APIEndpoint {
        return APIEndpoint(path: "jobs/\(id)/apply", method: .POST)
    }
    
    // Applications
    static let getUserApplications = APIEndpoint(path: "applications/user", method: .GET)
    static func getJobApplications(jobId: String) -> APIEndpoint {
        return APIEndpoint(path: "applications/job/\(jobId)", method: .GET)
    }
    static func updateApplicationStatus(id: String) -> APIEndpoint {
        return APIEndpoint(path: "applications/\(id)/status", method: .PUT)
    }
    
    // Custom endpoint
    static func custom(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: String] = [:],
        body: AnyEncodable? = nil
    ) -> APIEndpoint {
        return APIEndpoint(
            path: path,
            method: method,
            queryParameters: queryParameters,
            body: body
        )
    }
}

// MARK: - HTTP Method

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

// MARK: - Any Encodable Wrapper

public struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void
    
    public init<T: Encodable>(_ encodable: T) {
        encode = encodable.encode(to:)
    }
    
    public func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}

// MARK: - Network Errors

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noAuthToken
    case noRefreshToken
    case unauthorized
    case forbidden
    case notFound
    case rateLimited
    case validationError(APIError)
    case apiError(APIError)
    case httpError(Int)
    case serverError(Int)
    case invalidResponse
    case decodingError(DecodingError)
    case tokenRefreshFailed
    case networkUnavailable
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noAuthToken:
            return "No authentication token available"
        case .noRefreshToken:
            return "No refresh token available"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .rateLimited:
            return "Rate limit exceeded"
        case .validationError(let error):
            return "Validation error: \(error.message)"
        case .apiError(let error):
            return "API error: \(error.message)"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidResponse:
            return "Invalid response format"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .tokenRefreshFailed:
            return "Failed to refresh authentication token"
        case .networkUnavailable:
            return "Network unavailable"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .unauthorized, .tokenRefreshFailed:
            return "Please log in again."
        case .forbidden:
            return "You don't have permission to access this resource."
        case .notFound:
            return "The requested resource was not found."
        case .rateLimited:
            return "Please wait before making more requests."
        case .networkUnavailable:
            return "Please check your internet connection."
        case .serverError:
            return "Please try again later."
        default:
            return "Please try again."
        }
    }
}

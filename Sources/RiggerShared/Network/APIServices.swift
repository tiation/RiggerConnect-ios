//
//  APIServices.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - API Service Protocol

public protocol APIServiceProtocol {
    var networkLayer: NetworkLayerProtocol { get }
    var isUsingMockData: Bool { get }
}

// MARK: - Base API Service

public class BaseAPIService: APIServiceProtocol {
    public let networkLayer: NetworkLayerProtocol
    public let isUsingMockData: Bool
    
    public init(networkLayer: NetworkLayerProtocol? = nil, useMockData: Bool = false) {
        self.isUsingMockData = useMockData
        
        if useMockData {
            self.networkLayer = MockNetworkLayer()
        } else {
            self.networkLayer = networkLayer ?? NetworkLayer.shared
        }
    }
}

// MARK: - Authentication Service

public final class AuthService: BaseAPIService {
    public static let shared = AuthService()
    
    // MARK: - Authentication Methods
    
    public func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)
        let endpoint = APIEndpoint(
            path: "auth/login",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        let response: AuthResponse = try await networkLayer.request(
            endpoint: endpoint,
            responseType: AuthResponse.self,
            requiresAuth: false
        )
        
        // Save authentication data
        TokenManager.shared.saveAuthResponse(response)
        
        return response
    }
    
    public func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> AuthResponse {
        let request = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        let endpoint = APIEndpoint(
            path: "auth/register",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        let response: AuthResponse = try await networkLayer.request(
            endpoint: endpoint,
            responseType: AuthResponse.self,
            requiresAuth: false
        )
        
        // Save authentication data
        TokenManager.shared.saveAuthResponse(response)
        
        return response
    }
    
    public func logout() {
        TokenManager.shared.clearSession()
    }
    
    public func refreshToken() async throws -> String {
        let endpoint = APIEndpoint(path: "auth/refresh", method: .POST)
        
        let response: AuthResponse = try await networkLayer.request(
            endpoint: endpoint,
            responseType: AuthResponse.self,
            requiresAuth: true
        )
        
        TokenManager.shared.updateTokens(accessToken: response.token)
        return response.token
    }
}

// MARK: - User Service

public final class UserService: BaseAPIService {
    public static let shared = UserService()
    
    public func getUserProfile() async throws -> User {
        return try await networkLayer.request(
            endpoint: .getUserProfile,
            responseType: User.self,
            requiresAuth: true
        )
    }
    
    public func updateUserProfile(
        firstName: String? = nil,
        lastName: String? = nil,
        bio: String? = nil
    ) async throws -> User {
        let request = UpdateUserProfileRequest(
            firstName: firstName,
            lastName: lastName,
            bio: bio
        )
        let endpoint = APIEndpoint(
            path: "users/profile",
            method: .PUT,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: User.self,
            requiresAuth: true
        )
    }
}

// MARK: - Job Service

public final class JobService: BaseAPIService {
    public static let shared = JobService()
    
    public func getJobs(
        filters: JobFilters? = nil,
        pagination: PaginationInput = PaginationInput()
    ) async throws -> PaginatedResponse<Job> {
        var queryParams: [String: String] = [
            "page": String(pagination.page),
            "limit": String(pagination.limit)
        ]
        
        if let filters = filters {
            if let location = filters.location {
                queryParams["location"] = location
            }
            if let skill = filters.skill {
                queryParams["skill"] = skill
            }
            if let salaryMin = filters.salaryMin {
                queryParams["salary_min"] = String(salaryMin)
            }
            if let salaryMax = filters.salaryMax {
                queryParams["salary_max"] = String(salaryMax)
            }
            if let searchTerm = filters.searchTerm {
                queryParams["search"] = searchTerm
            }
        }
        
        let endpoint = APIEndpoint(
            path: "jobs",
            method: .GET,
            queryParameters: queryParams
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: PaginatedResponse<Job>.self,
            requiresAuth: true
        )
    }
    
    public func getJob(id: String) async throws -> Job {
        return try await networkLayer.request(
            endpoint: .getJob(id: id),
            responseType: Job.self,
            requiresAuth: true
        )
    }
    
    public func createJob(_ request: CreateJobRequest) async throws -> Job {
        let endpoint = APIEndpoint(
            path: "jobs",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Job.self,
            requiresAuth: true
        )
    }
    
    public func applyToJob(
        jobId: String,
        coverLetter: String? = nil,
        resumeUrl: String? = nil
    ) async throws -> Application {
        let request = CreateApplicationRequest(
            jobId: jobId,
            coverLetter: coverLetter,
            resumeUrl: resumeUrl
        )
        let endpoint = APIEndpoint(
            path: "jobs/\(jobId)/apply",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Application.self,
            requiresAuth: true
        )
    }
}

// MARK: - Application Service

public final class ApplicationService: BaseAPIService {
    public static let shared = ApplicationService()
    
    public func getUserApplications() async throws -> [Application] {
        return try await networkLayer.request(
            endpoint: .getUserApplications,
            responseType: [Application].self,
            requiresAuth: true
        )
    }
    
    public func getJobApplications(jobId: String) async throws -> [Application] {
        return try await networkLayer.request(
            endpoint: .getJobApplications(jobId: jobId),
            responseType: [Application].self,
            requiresAuth: true
        )
    }
    
    public func updateApplicationStatus(
        applicationId: String,
        status: ApplicationStatus
    ) async throws -> Application {
        let request = UpdateApplicationStatusRequest(status: status)
        let endpoint = APIEndpoint(
            path: "applications/\(applicationId)/status",
            method: .PUT,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Application.self,
            requiresAuth: true
        )
    }
    
    public func getApplicationAnalytics() async throws -> ApplicationAnalytics {
        return try await networkLayer.request(
            endpoint: APIEndpoint(path: "applications/analytics", method: .GET),
            responseType: ApplicationAnalytics.self,
            requiresAuth: true
        )
    }
}

// MARK: - Booking Service

public final class BookingService: BaseAPIService {
    public static let shared = BookingService()
    
    public func getBookings(
        filters: BookingFilters? = nil,
        pagination: PaginationInput = PaginationInput()
    ) async throws -> PaginatedResponse<Booking> {
        var queryParams: [String: String] = [
            "page": String(pagination.page),
            "limit": String(pagination.limit)
        ]
        
        if let filters = filters {
            if let status = filters.status {
                queryParams["status"] = status.rawValue
            }
            if let location = filters.location {
                queryParams["location"] = location
            }
            if let workerId = filters.workerId {
                queryParams["worker_id"] = workerId
            }
            if let businessId = filters.businessId {
                queryParams["business_id"] = businessId
            }
            // Add date filters if needed
        }
        
        let endpoint = APIEndpoint(
            path: "bookings",
            method: .GET,
            queryParameters: queryParams
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: PaginatedResponse<Booking>.self,
            requiresAuth: true
        )
    }
    
    public func getBooking(id: String) async throws -> Booking {
        return try await networkLayer.request(
            endpoint: APIEndpoint(path: "bookings/\(id)", method: .GET),
            responseType: Booking.self,
            requiresAuth: true
        )
    }
    
    public func createBooking(_ request: CreateBookingRequest) async throws -> Booking {
        let endpoint = APIEndpoint(
            path: "bookings",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Booking.self,
            requiresAuth: true
        )
    }
    
    public func updateBookingStatus(
        bookingId: String,
        status: BookingStatus,
        notes: String? = nil
    ) async throws -> Booking {
        let request = UpdateBookingStatusRequest(status: status, notes: notes)
        let endpoint = APIEndpoint(
            path: "bookings/\(bookingId)/status",
            method: .PUT,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Booking.self,
            requiresAuth: true
        )
    }
}

// MARK: - Review Service

public final class ReviewService: BaseAPIService {
    public static let shared = ReviewService()
    
    public func getReviews(
        filters: ReviewFilters? = nil,
        pagination: PaginationInput = PaginationInput()
    ) async throws -> PaginatedResponse<Review> {
        var queryParams: [String: String] = [
            "page": String(pagination.page),
            "limit": String(pagination.limit)
        ]
        
        if let filters = filters {
            if let reviewType = filters.reviewType {
                queryParams["type"] = reviewType.rawValue
            }
            if let revieweeId = filters.revieweeId {
                queryParams["reviewee"] = revieweeId
            }
            if let rating = filters.rating {
                queryParams["rating"] = String(rating)
            }
            if let status = filters.status {
                queryParams["status"] = status.rawValue
            }
        }
        
        let endpoint = APIEndpoint(
            path: "reviews",
            method: .GET,
            queryParameters: queryParams
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: PaginatedResponse<Review>.self,
            requiresAuth: true
        )
    }
    
    public func createReview(_ request: CreateReviewRequest) async throws -> Review {
        let endpoint = APIEndpoint(
            path: "reviews",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Review.self,
            requiresAuth: true
        )
    }
    
    public func updateReview(
        reviewId: String,
        request: UpdateReviewRequest
    ) async throws -> Review {
        let endpoint = APIEndpoint(
            path: "reviews/\(reviewId)",
            method: .PUT,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Review.self,
            requiresAuth: true
        )
    }
    
    public func getReviewAnalytics(for userId: String) async throws -> ReviewAnalytics {
        return try await networkLayer.request(
            endpoint: APIEndpoint(path: "reviews/analytics/\(userId)", method: .GET),
            responseType: ReviewAnalytics.self,
            requiresAuth: true
        )
    }
    
    public func createReviewResponse(_ request: CreateReviewResponseRequest) async throws -> ReviewResponse {
        let endpoint = APIEndpoint(
            path: "reviews/responses",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: ReviewResponse.self,
            requiresAuth: true
        )
    }
}

// MARK: - Payment Service

public final class PaymentService: BaseAPIService {
    public static let shared = PaymentService()
    
    public func getPayments(
        filters: PaymentFilters? = nil,
        pagination: PaginationInput = PaginationInput()
    ) async throws -> PaginatedResponse<Payment> {
        var queryParams: [String: String] = [
            "page": String(pagination.page),
            "limit": String(pagination.limit)
        ]
        
        if let filters = filters {
            if let status = filters.status {
                queryParams["status"] = status.rawValue
            }
            if let currency = filters.currency {
                queryParams["currency"] = currency
            }
            if let paymentMethod = filters.paymentMethod {
                queryParams["method"] = paymentMethod.rawValue
            }
            if let jobId = filters.jobId {
                queryParams["job_id"] = jobId
            }
        }
        
        let endpoint = APIEndpoint(
            path: "payments",
            method: .GET,
            queryParameters: queryParams
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: PaginatedResponse<Payment>.self,
            requiresAuth: true
        )
    }
    
    public func createPayment(_ request: CreatePaymentRequest) async throws -> Payment {
        let endpoint = APIEndpoint(
            path: "payments",
            method: .POST,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Payment.self,
            requiresAuth: true
        )
    }
    
    public func updatePaymentStatus(
        paymentId: String,
        status: PaymentStatus,
        referenceNumber: String? = nil
    ) async throws -> Payment {
        let request = UpdatePaymentStatusRequest(
            status: status,
            referenceNumber: referenceNumber
        )
        let endpoint = APIEndpoint(
            path: "payments/\(paymentId)/status",
            method: .PUT,
            body: AnyEncodable(request)
        )
        
        return try await networkLayer.request(
            endpoint: endpoint,
            responseType: Payment.self,
            requiresAuth: true
        )
    }
    
    public func getPaymentAnalytics() async throws -> PaymentAnalytics {
        return try await networkLayer.request(
            endpoint: APIEndpoint(path: "payments/analytics", method: .GET),
            responseType: PaymentAnalytics.self,
            requiresAuth: true
        )
    }
}

// MARK: - API Service Factory

public final class APIServiceFactory {
    public static let shared = APIServiceFactory()
    
    private let useMockData: Bool
    
    public init(useMockData: Bool = false) {
        self.useMockData = useMockData
    }
    
    // MARK: - Service Creation
    
    public lazy var authService: AuthService = {
        return AuthService(useMockData: useMockData)
    }()
    
    public lazy var userService: UserService = {
        return UserService(useMockData: useMockData)
    }()
    
    public lazy var jobService: JobService = {
        return JobService(useMockData: useMockData)
    }()
    
    public lazy var applicationService: ApplicationService = {
        return ApplicationService(useMockData: useMockData)
    }()
    
    public lazy var bookingService: BookingService = {
        return BookingService(useMockData: useMockData)
    }()
    
    public lazy var reviewService: ReviewService = {
        return ReviewService(useMockData: useMockData)
    }()
    
    public lazy var paymentService: PaymentService = {
        return PaymentService(useMockData: useMockData)
    }()
    
    // MARK: - Configuration
    
    public func switchToMockData() {
        // This would typically recreate services with mock data
        // For now, this is handled during initialization
    }
    
    public func switchToLiveData() {
        // This would typically recreate services with live data
        // For now, this is handled during initialization
    }
}

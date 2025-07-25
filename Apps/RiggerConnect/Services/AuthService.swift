//
//  AuthService.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import Combine
import SwiftUI

// MARK: - AuthService Implementation

class AuthService: ObservableObject, AuthServiceProtocol {
    
    // MARK: - Published Properties
    @Published var currentUser: AuthUser?
    var authState = CurrentValueSubject<AuthState, Never>(.idle)
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let currentUser = "current_user"
        static let authToken = "auth_token"
        static let refreshToken = "refresh_token"
    }
    
    // MARK: - Initialization
    init() {
        setupBindings()
        loadPersistedUser()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Sync published currentUser with authState
        $currentUser
            .map { user in
                if let user = user {
                    return AuthState.authenticated(user)
                } else {
                    return AuthState.unauthenticated
                }
            }
            .assign(to: \\.value, on: authState)
            .store(in: &cancellables)
    }
    
    private func loadPersistedUser() {
        if let userData = userDefaults.data(forKey: Keys.currentUser),
           let user = try? JSONDecoder().decode(AuthUser.self, from: userData) {
            currentUser = user
        } else {
            authState.send(.unauthenticated)
        }
    }
    
    // MARK: - AuthServiceProtocol Implementation
    
    func login(request: AuthLoginRequest) -> AnyPublisher<AuthTokenResponse, Error> {
        return Future { [weak self] promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Simulate network request
                self?.authState.send(.loading)
                
                // Mock successful login
                let mockUser = AuthUser(
                    id: UUID(),
                    email: request.email,
                    firstName: "Demo",
                    lastName: "User",
                    userType: .business,
                    isEmailVerified: true,
                    profileImageURL: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                let tokenResponse = AuthTokenResponse(
                    accessToken: "demo_access_token",
                    refreshToken: "demo_refresh_token",
                    expiresIn: 3600,
                    tokenType: "Bearer",
                    user: mockUser
                )
                
                // Persist user and tokens
                self?.saveUserAndTokens(tokenResponse)
                
                // Update current user
                self?.currentUser = mockUser
                
                promise(.success(tokenResponse))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(request: AuthSignUpRequest) -> AnyPublisher<AuthTokenResponse, Error> {
        return Future { [weak self] promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Simulate network request
                self?.authState.send(.loading)
                
                // Mock successful signup
                let mockUser = AuthUser(
                    id: UUID(),
                    email: request.email,
                    firstName: request.firstName,
                    lastName: request.lastName,
                    userType: request.userType,
                    isEmailVerified: false,
                    profileImageURL: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                let tokenResponse = AuthTokenResponse(
                    accessToken: "demo_access_token",
                    refreshToken: "demo_refresh_token",
                    expiresIn: 3600,
                    tokenType: "Bearer",
                    user: mockUser
                )
                
                // Persist user and tokens
                self?.saveUserAndTokens(tokenResponse)
                
                // Update current user
                self?.currentUser = mockUser
                
                promise(.success(tokenResponse))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func forgotPassword(request: AuthForgotPasswordRequest) -> AnyPublisher<Void, Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Simulate sending reset email
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func resetPassword(request: AuthResetPasswordRequest) -> AnyPublisher<Void, Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Simulate password reset
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            DispatchQueue.main.async {
                // Clear persisted data
                self?.clearPersistedData()
                
                // Clear current user
                self?.currentUser = nil
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<AuthTokenResponse, Error> {
        return Future { [weak self] promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let currentUser = self?.currentUser else {
                    promise(.failure(AuthError.invalidToken))
                    return
                }
                
                let tokenResponse = AuthTokenResponse(
                    accessToken: "new_demo_access_token",
                    refreshToken: "new_demo_refresh_token",
                    expiresIn: 3600,
                    tokenType: "Bearer",
                    user: currentUser
                )
                
                // Update stored tokens
                self?.saveTokens(tokenResponse)
                
                promise(.success(tokenResponse))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Public Methods
    
    func checkAuthenticationStatus() {
        if currentUser != nil {
            authState.send(.authenticated(currentUser!))
        } else {
            authState.send(.unauthenticated)
        }
    }
    
    // MARK: - Private Methods
    
    private func saveUserAndTokens(_ tokenResponse: AuthTokenResponse) {
        saveTokens(tokenResponse)
        
        // Save user
        if let userData = try? JSONEncoder().encode(tokenResponse.user) {
            userDefaults.set(userData, forKey: Keys.currentUser)
        }
    }
    
    private func saveTokens(_ tokenResponse: AuthTokenResponse) {
        userDefaults.set(tokenResponse.accessToken, forKey: Keys.authToken)
        userDefaults.set(tokenResponse.refreshToken, forKey: Keys.refreshToken)
    }
    
    private func clearPersistedData() {
        userDefaults.removeObject(forKey: Keys.currentUser)
        userDefaults.removeObject(forKey: Keys.authToken)
        userDefaults.removeObject(forKey: Keys.refreshToken)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

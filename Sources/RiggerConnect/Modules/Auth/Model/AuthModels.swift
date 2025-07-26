//
//  AuthModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import Combine

// MARK: - Auth Models

struct AuthUser: Codable, Identifiable, Equatable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let userType: UserType
    let isEmailVerified: Bool
    let profileImageURL: String?
    let createdAt: Date
    let updatedAt: Date
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct AuthCredentials: Codable {
    let email: String
    let password: String
}

struct AuthSignUpRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let userType: UserType
    let acceptedTerms: Bool
}

struct AuthLoginRequest: Codable {
    let email: String
    let password: String
    let rememberMe: Bool
}

struct AuthTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: TimeInterval
    let tokenType: String
    let user: AuthUser
}

struct AuthForgotPasswordRequest: Codable {
    let email: String
}

struct AuthResetPasswordRequest: Codable {
    let token: String
    let newPassword: String
    let confirmPassword: String
}

enum UserType: String, Codable, CaseIterable {
    case rigger = "rigger"
    case business = "business"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .rigger:
            return "Rigger"
        case .business:
            return "Business"
        case .admin:
            return "Administrator"
        }
    }
}

enum AuthError: Error, LocalizedError, Equatable {
    case invalidCredentials
    case userNotFound
    case emailAlreadyExists
    case weakPassword
    case networkError(String)
    case invalidToken
    case emailNotVerified
    case accountLocked
    case invalidUserType
    case termsNotAccepted
    case passwordMismatch
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .userNotFound:
            return "User not found. Please check your email address."
        case .emailAlreadyExists:
            return "An account with this email already exists."
        case .weakPassword:
            return "Password must be at least 8 characters with uppercase, lowercase, and numbers."
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidToken:
            return "Invalid or expired token. Please try again."
        case .emailNotVerified:
            return "Please verify your email address before logging in."
        case .accountLocked:
            return "Your account has been temporarily locked. Please contact support."
        case .invalidUserType:
            return "Invalid user type selected."
        case .termsNotAccepted:
            return "You must accept the terms and conditions to continue."
        case .passwordMismatch:
            return "Passwords do not match. Please try again."
        }
    }
    
    // MARK: - Equatable
    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidCredentials, .invalidCredentials),
             (.userNotFound, .userNotFound),
             (.emailAlreadyExists, .emailAlreadyExists),
             (.weakPassword, .weakPassword),
             (.invalidToken, .invalidToken),
             (.emailNotVerified, .emailNotVerified),
             (.accountLocked, .accountLocked),
             (.invalidUserType, .invalidUserType),
             (.termsNotAccepted, .termsNotAccepted),
             (.passwordMismatch, .passwordMismatch):
            return true
        case (.networkError(let lhsMessage), .networkError(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Auth State

enum AuthState: Equatable {
    case idle
    case loading
    case authenticated(AuthUser)
    case unauthenticated
    case error(AuthError)
    
    var isAuthenticated: Bool {
        if case .authenticated = self {
            return true
        }
        return false
    }
    
    var user: AuthUser? {
        if case .authenticated(let user) = self {
            return user
        }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}

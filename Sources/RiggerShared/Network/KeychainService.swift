//
//  KeychainService.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation
import Security

// MARK: - Keychain Service

public final class KeychainService {
    public static let shared = KeychainService()
    
    private let service = "com.rigger.connect.api"
    
    private init() {}
    
    // MARK: - Token Management
    
    public func saveToken(_ token: String, for key: KeychainKey) throws {
        let data = token.data(using: .utf8)!
        try save(data: data, for: key)
    }
    
    public func getToken(for key: KeychainKey) throws -> String? {
        guard let data = try getData(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    public func deleteToken(for key: KeychainKey) throws {
        try delete(for: key)
    }
    
    // MARK: - Generic Data Operations
    
    private func save(data: Data, for key: KeychainKey) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete existing item first
        try? delete(for: key)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave(status: status)
        }
    }
    
    private func getData(for key: KeychainKey) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unableToRetrieve(status: status)
        }
    }
    
    private func delete(for key: KeychainKey) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete(status: status)
        }
    }
    
    // MARK: - Convenience Methods
    
    public func clearAllTokens() throws {
        for key in KeychainKey.allCases {
            try? delete(for: key)
        }
    }
    
    public func hasValidAccessToken() -> Bool {
        do {
            return try getToken(for: .accessToken) != nil
        } catch {
            return false
        }
    }
    
    public func hasValidRefreshToken() -> Bool {
        do {
            return try getToken(for: .refreshToken) != nil
        } catch {
            return false
        }
    }
}

// MARK: - Keychain Keys

public enum KeychainKey: String, CaseIterable {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case userId = "user_id"
    case userEmail = "user_email"
    
    public var displayName: String {
        switch self {
        case .accessToken: return "Access Token"
        case .refreshToken: return "Refresh Token"
        case .userId: return "User ID"
        case .userEmail: return "User Email"
        }
    }
}

// MARK: - Keychain Errors

public enum KeychainError: Error, LocalizedError {
    case unableToSave(status: OSStatus)
    case unableToRetrieve(status: OSStatus)
    case unableToDelete(status: OSStatus)
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .unableToSave(let status):
            return "Unable to save to keychain (status: \(status))"
        case .unableToRetrieve(let status):
            return "Unable to retrieve from keychain (status: \(status))"
        case .unableToDelete(let status):
            return "Unable to delete from keychain (status: \(status))"
        case .invalidData:
            return "Invalid data format"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .unableToSave, .unableToRetrieve, .unableToDelete:
            return "Please check device security settings and try again."
        case .invalidData:
            return "Please provide valid data format."
        }
    }
}

// MARK: - Token Manager

public final class TokenManager {
    public static let shared = TokenManager()
    
    private let keychain = KeychainService.shared
    
    private init() {}
    
    // MARK: - Access Token Management
    
    public var accessToken: String? {
        get {
            try? keychain.getToken(for: .accessToken)
        }
        set {
            if let token = newValue {
                try? keychain.saveToken(token, for: .accessToken)
            } else {
                try? keychain.deleteToken(for: .accessToken)
            }
        }
    }
    
    // MARK: - Refresh Token Management
    
    public var refreshToken: String? {
        get {
            try? keychain.getToken(for: .refreshToken)
        }
        set {
            if let token = newValue {
                try? keychain.saveToken(token, for: .refreshToken)
            } else {
                try? keychain.deleteToken(for: .refreshToken)
            }
        }
    }
    
    // MARK: - User Info Management
    
    public var userId: String? {
        get {
            try? keychain.getToken(for: .userId)
        }
        set {
            if let id = newValue {
                try? keychain.saveToken(id, for: .userId)
            } else {
                try? keychain.deleteToken(for: .userId)
            }
        }
    }
    
    public var userEmail: String? {
        get {
            try? keychain.getToken(for: .userEmail)
        }
        set {
            if let email = newValue {
                try? keychain.saveToken(email, for: .userEmail)
            } else {
                try? keychain.deleteToken(for: .userEmail)
            }
        }
    }
    
    // MARK: - Authentication State
    
    public var isAuthenticated: Bool {
        return accessToken != nil
    }
    
    public var canRefreshToken: Bool {
        return refreshToken != nil
    }
    
    // MARK: - Session Management
    
    public func saveAuthResponse(_ response: AuthResponse) {
        accessToken = response.token
        userId = response.user.id
        userEmail = response.user.email
        
        NotificationCenter.default.post(
            name: .userDidLogin,
            object: response.user
        )
    }
    
    public func clearSession() {
        accessToken = nil
        refreshToken = nil
        userId = nil
        userEmail = nil
        
        NotificationCenter.default.post(
            name: .userDidLogout,
            object: nil
        )
    }
    
    public func updateTokens(accessToken: String, refreshToken: String? = nil) {
        self.accessToken = accessToken
        if let refreshToken = refreshToken {
            self.refreshToken = refreshToken
        }
        
        NotificationCenter.default.post(
            name: .tokenDidRefresh,
            object: accessToken
        )
    }
}

// MARK: - Notification Extensions

public extension Notification.Name {
    static let userDidLogin = Notification.Name("UserDidLogin")
    static let userDidLogout = Notification.Name("UserDidLogout")
    static let tokenDidRefresh = Notification.Name("TokenDidRefresh")
}

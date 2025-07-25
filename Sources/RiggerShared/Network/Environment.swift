//
//  Environment.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Environment Configuration

public enum Environment: String, CaseIterable {
    case development = "development"
    case staging = "staging"
    case production = "production"
    
    public var displayName: String {
        switch self {
        case .development: return "Development"
        case .staging: return "Staging"
        case .production: return "Production"
        }
    }
    
    public var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "http://localhost:3000/api/v1")!
        case .staging:
            return URL(string: "https://staging-api.rigger.sxc.codes/api/v1")!
        case .production:
            return URL(string: "https://api.rigger.sxc.codes/api/v1")!
        }
    }
    
    public var websocketURL: URL {
        switch self {
        case .development:
            return URL(string: "ws://localhost:3000/ws")!
        case .staging:
            return URL(string: "wss://staging-api.rigger.sxc.codes/ws")!
        case .production:
            return URL(string: "wss://api.rigger.sxc.codes/ws")!
        }
    }
    
    public var timeout: TimeInterval {
        switch self {
        case .development:
            return 30.0
        case .staging:
            return 60.0
        case .production:
            return 30.0
        }
    }
    
    public var isDebugLoggingEnabled: Bool {
        switch self {
        case .development:
            return true
        case .staging:
            return true
        case .production:
            return false
        }
    }
    
    public var rateLimitRetryAttempts: Int {
        switch self {
        case .development:
            return 3
        case .staging:
            return 5
        case .production:
            return 3
        }
    }
}

// MARK: - Environment Configuration Manager

public final class EnvironmentConfig {
    public static let shared = EnvironmentConfig()
    
    private var _currentEnvironment: Environment
    
    private init() {
        // Default to production for safety
        self._currentEnvironment = .production
        
        // Try to load from bundle configuration or user defaults
        if let environmentString = Bundle.main.object(forInfoDictionaryKey: "API_ENVIRONMENT") as? String,
           let environment = Environment(rawValue: environmentString.lowercased()) {
            self._currentEnvironment = environment
        } else if let savedEnvironment = UserDefaults.standard.string(forKey: "selected_environment"),
                  let environment = Environment(rawValue: savedEnvironment) {
            self._currentEnvironment = environment
        }
    }
    
    public var currentEnvironment: Environment {
        get { _currentEnvironment }
        set {
            _currentEnvironment = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: "selected_environment")
        }
    }
    
    public var baseURL: URL {
        return currentEnvironment.baseURL
    }
    
    public var websocketURL: URL {
        return currentEnvironment.websocketURL
    }
    
    public var timeout: TimeInterval {
        return currentEnvironment.timeout
    }
    
    public var isDebugLoggingEnabled: Bool {
        return currentEnvironment.isDebugLoggingEnabled
    }
    
    public var rateLimitRetryAttempts: Int {
        return currentEnvironment.rateLimitRetryAttempts
    }
    
    // MARK: - Helper Methods
    
    public func switchEnvironment(to environment: Environment) {
        currentEnvironment = environment
        NotificationCenter.default.post(
            name: .environmentDidChange,
            object: environment
        )
    }
    
    public func reset() {
        UserDefaults.standard.removeObject(forKey: "selected_environment")
        _currentEnvironment = .production
    }
}

// MARK: - Notification Extensions

public extension Notification.Name {
    static let environmentDidChange = Notification.Name("EnvironmentDidChange")
}

// MARK: - API Configuration

public struct APIConfig {
    public let environment: Environment
    public let baseURL: URL
    public let timeout: TimeInterval
    public let maxRetryAttempts: Int
    public let retryDelay: TimeInterval
    
    public init(
        environment: Environment = EnvironmentConfig.shared.currentEnvironment,
        baseURL: URL? = nil,
        timeout: TimeInterval? = nil,
        maxRetryAttempts: Int = 3,
        retryDelay: TimeInterval = 1.0
    ) {
        self.environment = environment
        self.baseURL = baseURL ?? environment.baseURL
        self.timeout = timeout ?? environment.timeout
        self.maxRetryAttempts = maxRetryAttempts
        self.retryDelay = retryDelay
    }
}

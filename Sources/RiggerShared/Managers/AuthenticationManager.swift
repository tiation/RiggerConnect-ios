//
//  AuthenticationManager.swift
//  RiggerShared
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation
import SwiftUI
import FirebaseAuth
import Logging

@MainActor
public class AuthenticationManager: ObservableObject {
    
    @Published public var isAuthenticated = false
    @Published public var currentUser: User?
    
    private let logger = Logger(label: "com.chasewhiterabbit.rigger.auth")
    
    public init() {
        // Check if user is already signed in
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.isAuthenticated = true
            logger.info("User already signed in: \(user.email ?? "unknown")")
        }
        
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
                if let userEmail = user?.email {
                    self?.logger.info("Auth state changed - User: \(userEmail)")
                } else {
                    self?.logger.info("Auth state changed - User signed out")
                }
            }
        }
    }
    
    public func signIn(email: String, password: String) async throws {
        logger.info("Attempting sign in for: \(email)")
        
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        logger.info("Sign in successful for: \(result.user.email ?? "unknown")")
    }
    
    public func signUp(email: String, password: String) async throws {
        logger.info("Attempting sign up for: \(email)")
        
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        logger.info("Sign up successful for: \(result.user.email ?? "unknown")")
    }
    
    public func signOut() throws {
        logger.info("Signing out user")
        try Auth.auth().signOut()
    }
    
    public func checkAuthenticationState() async {
        // This method can be used to refresh auth state if needed
        logger.debug("Checking authentication state")
    }
}

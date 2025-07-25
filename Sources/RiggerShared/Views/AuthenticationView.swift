//
//  AuthenticationView.swift
//  RiggerShared
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import SwiftUI
import FirebaseAuth

public struct AuthenticationView: View {
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo and Title
                VStack(spacing: 10) {
                    Image(systemName: "hammer.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.riggerOrange)
                    
                    Text("RiggerConnect")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("🏗️ ChaseWhiteRabbit NGO Initiative")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Form
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(isSignUp ? .newPassword : .password)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: authenticate) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text(isSignUp ? "Sign Up" : "Sign In")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.riggerOrange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                    
                    Button(action: { isSignUp.toggle() }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                    }
                    .foregroundColor(.riggerBlue)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Footer
                VStack(spacing: 5) {
                    Text("Ethical Technology for Worker Empowerment")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Built by Jack Jonas & Tia")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func authenticate() {
        guard !email.isEmpty && !password.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                if isSignUp {
                    try await authenticationManager.signUp(email: email, password: password)
                } else {
                    try await authenticationManager.signIn(email: email, password: password)
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Color Extensions

public extension Color {
    static let riggerOrange = Color(red: 1.0, green: 0.4, blue: 0.0)
    static let riggerBlue = Color(red: 0.0, green: 0.3, blue: 0.6)
    static let riggerGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let riggerGreen = Color(red: 0.0, green: 0.6, blue: 0.2)
    
    // ChaseWhiteRabbit NGO Brand Colors
    static let ngoGreen = Color(red: 0.0, green: 0.7, blue: 0.4)
    static let ngoBlue = Color(red: 0.0, green: 0.4, blue: 0.8)
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationManager())
}

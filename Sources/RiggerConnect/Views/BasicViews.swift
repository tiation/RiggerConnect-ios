//
//  BasicViews.swift
//  RiggerConnect
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import SwiftUI
import RiggerShared

// MARK: - Business Onboarding View

public struct BusinessOnboardingView: View {
    
    @EnvironmentObject private var businessManager: BusinessManager
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 16) {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.riggerOrange)
                    
                    Text("Welcome to RiggerConnect")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Let's set up your business profile")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("🏗️ Find qualified riggers and construction workers")
                    Text("💼 Post job opportunities easily")
                    Text("📊 Manage applications and candidates")
                    Text("🤝 Connect with industry professionals")
                }
                .font(.headline)
                .foregroundColor(.riggerBlue)
                
                Spacer()
                
                Button("Complete Profile Setup") {
                    Task {
                        await businessManager.loadBusinessProfile()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.riggerOrange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 30)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Dashboard View

public struct DashboardView: View {
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Welcome to RiggerConnect Business")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        DashboardCard(
                            title: "Active Jobs",
                            value: "12",
                            icon: "briefcase.fill",
                            color: .riggerOrange
                        )
                        
                        DashboardCard(
                            title: "Applications",
                            value: "48",
                            icon: "person.2.fill",
                            color: .riggerBlue
                        )
                        
                        DashboardCard(
                            title: "Messages",
                            value: "7",
                            icon: "message.fill",
                            color: .riggerGreen
                        )
                        
                        DashboardCard(
                            title: "Profile Views",
                            value: "124",
                            icon: "eye.fill",
                            color: .ngoBlue
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Other Basic Views

public struct JobPostingsView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Job Postings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Manage your job postings here")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

public struct ApplicationsView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Applications")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Review candidate applications")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

public struct MessagesView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Messages")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Communicate with candidates")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

public struct BusinessProfileView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Business Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Manage your company information")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Helper Views

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

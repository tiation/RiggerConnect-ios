//
//  BasicViews.swift
//  RiggerHub
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import SwiftUI
import RiggerShared

// MARK: - Worker Onboarding View

public struct WorkerOnboardingView: View {
    
    @EnvironmentObject private var workerManager: WorkerManager
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 16) {
                    Image(systemName: "hammer.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.riggerBlue)
                    
                    Text("Welcome to RiggerHub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Let's set up your worker profile")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("🔍 Discover job opportunities")
                    Text("🏗️ Showcase your rigging skills")
                    Text("📋 Track your applications")
                    Text("💬 Connect with employers")
                }
                .font(.headline)
                .foregroundColor(.riggerOrange)
                
                Spacer()
                
                Button("Complete Profile Setup") {
                    Task {
                        await workerManager.loadWorkerProfile()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.riggerBlue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 30)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Worker Dashboard View

public struct WorkerDashboardView: View {
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Welcome to RiggerHub")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        WorkerDashboardCard(
                            title: "Available Jobs",
                            value: "23",
                            icon: "magnifyingglass",
                            color: .riggerBlue
                        )
                        
                        WorkerDashboardCard(
                            title: "Applications",
                            value: "5",
                            icon: "doc.text.fill",
                            color: .riggerOrange
                        )
                        
                        WorkerDashboardCard(
                            title: "Messages",
                            value: "3",
                            icon: "message.fill",
                            color: .riggerGreen
                        )
                        
                        WorkerDashboardCard(
                            title: "Profile Score",
                            value: "92%",
                            icon: "star.fill",
                            color: .ngoGreen
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

// MARK: - Job Discovery View

public struct JobDiscoveryView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Job Discovery")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Find your next opportunity")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 16) {
                    JobCard(
                        title: "Senior Rigger",
                        company: "Perth Construction Co.",
                        location: "Perth, WA",
                        salary: "$80,000 - $95,000"
                    )
                    
                    JobCard(
                        title: "Crane Operator",
                        company: "Mining Solutions Ltd",
                        location: "Karratha, WA",
                        salary: "$90,000 - $110,000"
                    )
                    
                    JobCard(
                        title: "Dogman",
                        company: "Heavy Lift Services",
                        location: "Broome, WA",
                        salary: "$70,000 - $85,000"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Worker Messages View

public struct WorkerMessagesView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Messages")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Communicate with employers")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Worker Profile View

public struct WorkerProfileView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Worker Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Manage your professional information")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Helper Views

struct WorkerDashboardCard: View {
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

struct JobCard: View {
    let title: String
    let company: String
    let location: String
    let salary: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(company)
                .font(.subheadline)
                .foregroundColor(.riggerOrange)
            
            HStack {
                Label(location, systemImage: "location")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(salary)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.riggerGreen)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

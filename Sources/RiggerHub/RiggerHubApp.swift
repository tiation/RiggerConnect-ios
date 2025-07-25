//
//  RiggerHubApp.swift
//  RiggerHub iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import RiggerShared
import Logging

@main
public struct RiggerHubApp: App {
    
    // MARK: - Properties
    
    @StateObject private var authenticationManager = AuthenticationManager()
    @StateObject private var workerManager = WorkerManager()
    @StateObject private var jobDiscoveryManager = JobDiscoveryManager()
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var notificationManager = NotificationManager()
    
    private let logger = Logger(label: "com.chasewhiterabbit.riggerhub.app")
    
    // MARK: - App Lifecycle
    
    public init() {
        setupFirebase()
        setupLogging()
    }
    
    public var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticationManager)
                .environmentObject(workerManager)
                .environmentObject(jobDiscoveryManager)
                .environmentObject(subscriptionManager)
                .environmentObject(notificationManager)
                .onAppear {
                    setupNotifications()
                    trackAppLaunch()
                }
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupFirebase() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            logger.warning("GoogleService-Info.plist not found")
            return
        }
        
        guard let plistData = NSDictionary(contentsOfFile: path) else {
            logger.error("Failed to load GoogleService-Info.plist")
            return
        }
        
        FirebaseApp.configure()
        logger.info("Firebase configured successfully")
    }
    
    private func setupLogging() {
        #if DEBUG
        LoggingSystem.bootstrap { label in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = .debug
            return handler
        }
        #else
        LoggingSystem.bootstrap { label in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = .info
            return handler
        }
        #endif
    }
    
    private func setupNotifications() {
        Task {
            await notificationManager.requestPermissions()
        }
    }
    
    private func trackAppLaunch() {
        logger.info("🏗️ RiggerHub iOS launched - Supporting WA Mining  Construction")
        logger.info("💚 ChaseWhiteRabbit NGO - Ethical Technology for Worker Empowerment")
        
        // Track app launch for analytics
        Task {
            await workerManager.trackAppLaunch()
        }
    }
}

// MARK: - Content View

struct ContentView: View {
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @EnvironmentObject private var workerManager: WorkerManager
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    
    var body: some View {
        Group {
            if authenticationManager.isAuthenticated {
                if workerManager.isWorkerProfileComplete {
                    MainTabView()
                } else {
                    WorkerOnboardingView()
                }
            } else {
                AuthenticationView()
            }
        }
        .task {
            await authenticationManager.checkAuthenticationState()
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    
    @EnvironmentObject private var jobDiscoveryManager: JobDiscoveryManager
    @EnvironmentObject private var workerManager: WorkerManager
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    
    var body: some View {
        TabView {
            // Dashboard Tab
            WorkerDashboardView()
                .tabItem {
                    Image(systemName: "homekit")
                    Text("Dashboard")
                }
            
            // Job Discovery Tab
            JobDiscoveryView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Jobs")
                }
            
            // Messages Tab
            WorkerMessagesView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messages")
                }
            
            // Profile Tab
            WorkerProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.riggerBlue)
        .onAppear {
            // Load initial data
            Task {
                await loadInitialData()
            }
        }
    }
    
    private func loadInitialData() async {
        async let jobListings = jobDiscoveryManager.loadAvailableJobs()
        async let workerProfile = workerManager.loadWorkerProfile()
        async let subscription = subscriptionManager.loadSubscriptionDetails()
        
        await (jobListings, workerProfile, subscription)
    }
}

// MARK: - Color Extensions

extension Color {
    static let riggerOrange = Color(red: 1.0, green: 0.4, blue: 0.0)
    static let riggerBlue = Color(red: 0.0, green: 0.3, blue: 0.6)
    static let riggerGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let riggerGreen = Color(red: 0.0, green: 0.6, blue: 0.2)
    
    // ChaseWhiteRabbit NGO Brand Colors
    static let ngoGreen = Color(red: 0.0, green: 0.7, blue: 0.4)
    static let ngoBlue = Color(red: 0.0, green: 0.4, blue: 0.8)
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(WorkerManager())
        .environmentObject(JobDiscoveryManager())
        .environmentObject(SubscriptionManager())
        .environmentObject(NotificationManager())
}


//
//  RiggerConnectApp.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import SwiftUI
import UIKit
import Combine

@main
struct RiggerConnectApp: App {
    
    // MARK: - Properties
    @StateObject private var authService = AuthService()
    private let dependencyContainer = DependencyResolver.shared
    
    // MARK: - Initialization
    init() {
        setupDependencies()
        configureApp()
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .onAppear {
                    authService.checkAuthenticationStatus()
                }
        }
    }
    
    // MARK: - Setup Methods
    private func setupDependencies() {
        DependencyConfigurator.configure(container: dependencyContainer)
    }
    
    private func configureApp() {
        // Configure Firebase, logging, etc.
        FirebaseConfigurator.configure()
    }
}

// MARK: - Content View

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    @State private var navigationController: UINavigationController?
    
    var body: some View {
        NavigationView {
            Group {
                switch authService.authState.value {
                case .loading:
                    LoadingView()
                case .authenticated(let user):
                    MainAppView(user: user)
                case .unauthenticated, .error, .idle:
                    AuthenticationView()
                }
            }
        }
        .onAppear {
            setupNavigationController()
        }
    }
    
    private func setupNavigationController() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController as? UINavigationController {
            navigationController = rootViewController
        }
    }
}

// MARK: - Authentication View

struct AuthenticationView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController = UINavigationController()
        let container = DependencyResolver.shared
        
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        authCoordinator.onAuthenticationComplete = {
            // Handle successful authentication
            print("Authentication completed successfully")
        }
        
        authCoordinator.start()
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Handle updates if needed
    }
}

// MARK: - Main App View

struct MainAppView: View {
    let user: AuthUser
    
    var body: some View {
        TabView {
            DashboardView(user: user)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
            
            JobSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search Jobs")
                }
            
            BookingView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Bookings")
                }
            
            ProfileView(user: user)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.blue)
    }
}

// MARK: - Dashboard View

struct DashboardView: View {
    let user: AuthUser
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Welcome Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back, \(user.firstName)!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("What would you like to do today?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Quick Actions
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    QuickActionCard(
                        title: "Post Job",
                        icon: "plus.circle.fill",
                        color: .blue
                    )
                    
                    QuickActionCard(
                        title: "Find Workers",
                        icon: "person.2.fill",
                        color: .green
                    )
                    
                    QuickActionCard(
                        title: "View Analytics",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .orange
                    )
                    
                    QuickActionCard(
                        title: "Manage Payments",
                        icon: "creditcard.fill",
                        color: .purple
                    )
                }
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        ActivityRow(
                            title: "New job application received",
                            subtitle: "Senior Rigger position",
                            time: "2 hours ago"
                        )
                        
                        ActivityRow(
                            title: "Payment processed",
                            subtitle: "$2,500.00 for Project ABC",
                            time: "1 day ago"
                        )
                        
                        ActivityRow(
                            title: "Worker profile updated",
                            subtitle: "John Doe completed profile",
                            time: "2 days ago"
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}

// MARK: - Quick Action Card

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Handle action
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Activity Row

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Placeholder Views

struct JobSearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                Text("Job Search")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Search and filter available jobs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Job Search")
        }
    }
}

struct BookingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "calendar.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.green)
                
                Text("Bookings")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Manage your appointments and bookings")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Bookings")
        }
    }
}

struct ProfileView: View {
    let user: AuthUser
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile Image
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                // User Info
                VStack(spacing: 8) {
                    Text(user.fullName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(user.userType.displayName)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                // Profile Options
                VStack(spacing: 12) {
                    ProfileOptionRow(title: "Edit Profile", icon: "pencil")
                    ProfileOptionRow(title: "Skills & Certifications", icon: "star.fill")
                    ProfileOptionRow(title: "Work History", icon: "briefcase.fill")
                    ProfileOptionRow(title: "Reviews", icon: "star.bubble.fill")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

struct ProfileOptionRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {
            // Handle action
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "gearshape.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.gray)
                
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Configure your app preferences")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Settings")
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

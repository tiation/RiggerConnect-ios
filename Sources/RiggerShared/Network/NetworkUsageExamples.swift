//
//  NetworkUsageExamples.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Network Usage Examples

/*
 This file demonstrates how to use the NetworkLayer and API services
 in your iOS app. These examples show common usage patterns for the
 Rigger Connect API client.
 */

public class NetworkUsageExamples {
    
    // MARK: - Authentication Examples
    
    public static func loginExample() async {
        do {
            // Initialize auth service (can use mock data for testing)
            let authService = AuthService(useMockData: false)
            
            // Perform login
            let response = try await authService.login(
                email: "john.rigger@example.com",
                password: "securepassword123"
            )
            
            print("Login successful!")
            print("User: \(response.user.fullName)")
            print("Token saved to keychain")
            
        } catch let error as NetworkError {
            print("Login failed: \(error.errorDescription ?? "Unknown error")")
            print("Recovery suggestion: \(error.recoverySuggestion ?? "Try again")")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Job Search Examples
    
    public static func searchJobsExample() async {
        do {
            let jobService = JobService()
            
            // Create search filters
            let filters = JobFilters(
                location: "Perth",
                skill: "Advanced Rigging",
                salaryMin: 70000,
                searchTerm: "mining"
            )
            
            // Set pagination
            let pagination = PaginationInput(page: 1, limit: 20)
            
            // Fetch jobs
            let response = try await jobService.getJobs(
                filters: filters,
                pagination: pagination
            )
            
            print("Found \(response.pagination.total) jobs")
            for job in response.data {
                print("- \(job.title) at \(job.company) (\(job.location))")
                if let salary = job.salary {
                    print("  Salary: $\(Int(salary))")
                }
            }
            
        } catch {
            print("Job search failed: \(error)")
        }
    }
    
    // MARK: - Job Application Examples
    
    public static func applyToJobExample() async {
        do {
            let jobService = JobService()
            
            let application = try await jobService.applyToJob(
                jobId: "job123",
                coverLetter: "I am very interested in this position...",
                resumeUrl: "https://example.com/resume.pdf"
            )
            
            print("Application submitted successfully!")
            print("Application ID: \(application.id)")
            print("Status: \(application.status.displayName)")
            
        } catch {
            print("Application failed: \(error)")
        }
    }
    
    // MARK: - User Profile Examples
    
    public static func getUserProfileExample() async {
        do {
            let userService = UserService()
            
            let user = try await userService.getUserProfile()
            
            print("User Profile:")
            print("Name: \(user.fullName)")
            print("Email: \(user.email)")
            print("Role: \(user.role.displayName)")
            
            if let profile = user.profile {
                print("Bio: \(profile.bio ?? "No bio")")
                print("Skills: \(profile.skills.joined(separator: ", "))")
                print("Experience: \(profile.experience ?? 0) years")
            }
            
        } catch {
            print("Failed to fetch user profile: \(error)")
        }
    }
    
    // MARK: - Booking Management Examples
    
    public static func getBookingsExample() async {
        do {
            let bookingService = BookingService()
            
            let filters = BookingFilters(
                status: .confirmed,
                workerId: TokenManager.shared.userId
            )
            
            let response = try await bookingService.getBookings(
                filters: filters,
                pagination: PaginationInput(page: 1, limit: 10)
            )
            
            print("Found \(response.data.count) bookings")
            for booking in response.data {
                print("- \(booking.id): \(booking.status.displayName)")
                print("  Start: \(booking.bookingDetails.startDate)")
                print("  Location: \(booking.bookingDetails.location.siteName)")
            }
            
        } catch {
            print("Failed to fetch bookings: \(error)")
        }
    }
    
    // MARK: - Review Examples
    
    public static func createReviewExample() async {
        do {
            let reviewService = ReviewService()
            
            let reviewRequest = CreateReviewRequest(
                bookingId: "booking123",
                revieweeId: "user456",
                reviewType: .businessToWorker,
                rating: 5,
                title: "Excellent Work",
                comment: "John was professional and completed the job perfectly.",
                categories: ReviewCategories(
                    communication: 5,
                    professionalism: 5,
                    reliability: 5,
                    quality: 5,
                    safety: 5,
                    timeliness: 5
                ),
                isPublic: true
            )
            
            let review = try await reviewService.createReview(reviewRequest)
            
            print("Review created successfully!")
            print("Review ID: \(review.id)")
            print("Rating: \(review.rating)/5 stars")
            
        } catch {
            print("Failed to create review: \(error)")
        }
    }
    
    // MARK: - Environment Switching Examples
    
    public static func switchEnvironmentExample() {
        // Switch to staging environment
        EnvironmentConfig.shared.switchEnvironment(to: .staging)
        print("Switched to staging environment")
        print("Base URL: \(EnvironmentConfig.shared.baseURL)")
        
        // Switch back to production
        EnvironmentConfig.shared.switchEnvironment(to: .production)
        print("Switched to production environment")
    }
    
    // MARK: - Mock Data Examples
    
    public static func useMockDataExample() async {
        // Create services with mock data for testing/previews
        let mockJobService = JobService(useMockData: true)
        
        do {
            let response = try await mockJobService.getJobs()
            print("Mock data: \(response.data.count) jobs loaded")
            
            for job in response.data {
                print("- \(job.title) at \(job.company)")
            }
        } catch {
            print("Mock data error: \(error)")
        }
    }
    
    // MARK: - Error Handling Examples
    
    public static func errorHandlingExample() async {
        let jobService = JobService()
        
        do {
            let job = try await jobService.getJob(id: "nonexistent")
            print("Found job: \(job.title)")
            
        } catch NetworkError.unauthorized {
            print("User needs to log in again")
            // Trigger login flow
            
        } catch NetworkError.notFound {
            print("Job not found - may have been deleted")
            // Show appropriate message to user
            
        } catch NetworkError.rateLimited {
            print("Too many requests - please wait")
            // Show rate limit message
            
        } catch NetworkError.networkUnavailable {
            print("No internet connection")
            // Show offline mode or retry option
            
        } catch let NetworkError.validationError(apiError) {
            print("Validation failed: \(apiError.message)")
            if let details = apiError.details {
                for detail in details {
                    print("- \(detail.field): \(detail.message)")
                }
            }
            
        } catch {
            print("Unexpected error: \(error)")
            // Show generic error message
        }
    }
}

// MARK: - Network Helper Utilities

public class NetworkHelpers {
    
    // MARK: - Token Management Helpers
    
    public static func isUserLoggedIn() -> Bool {
        return TokenManager.shared.isAuthenticated
    }
    
    public static func getCurrentUser() -> (id: String?, email: String?) {
        return (
            id: TokenManager.shared.userId,
            email: TokenManager.shared.userEmail
        )
    }
    
    public static func clearUserSession() {
        TokenManager.shared.clearSession()
        print("User session cleared")
    }
    
    // MARK: - Environment Helpers
    
    public static func getCurrentEnvironment() -> Environment {
        return EnvironmentConfig.shared.currentEnvironment
    }
    
    public static func isDebugMode() -> Bool {
        return EnvironmentConfig.shared.isDebugLoggingEnabled
    }
    
    // MARK: - Network Status Helpers
    
    public static func checkNetworkStatus() {
        // In a real app, you might use Network framework
        // For now, this is a placeholder
        print("Network status: Connected")
    }
    
    // MARK: - API Service Factory Helpers
    
    public static func createMockServices() -> APIServiceFactory {
        return APIServiceFactory(useMockData: true)
    }
    
    public static func createLiveServices() -> APIServiceFactory {
        return APIServiceFactory(useMockData: false)
    }
    
    // MARK: - Date Formatting Helpers
    
    public static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    public static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - Preview Helpers for SwiftUI

#if DEBUG
public class PreviewHelpers {
    
    public static func setupMockEnvironment() {
        // Switch to development environment for previews
        EnvironmentConfig.shared.switchEnvironment(to: .development)
        
        // Set up mock authentication
        let mockUser = MockDataProvider.mockUsers[0]
        let mockAuth = AuthResponse(token: "preview_token", user: mockUser)
        TokenManager.shared.saveAuthResponse(mockAuth)
        
        print("Preview environment configured with mock data")
    }
    
    public static func tearDownMockEnvironment() {
        TokenManager.shared.clearSession()
        EnvironmentConfig.shared.switchEnvironment(to: .production)
        print("Preview environment cleaned up")
    }
}
#endif

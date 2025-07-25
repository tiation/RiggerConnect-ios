# RiggerConnect iOS Network Layer

This document provides comprehensive information about the NetworkLayer implementation for the RiggerConnect iOS application.

## Overview

The NetworkLayer provides a robust, enterprise-grade API client with the following features:

- **Async/await** support for modern Swift concurrency
- **Environment configuration** (Development, Staging, Production)
- **Secure token storage** via iOS Keychain
- **Automatic token refresh** when authentication expires
- **Comprehensive error handling** with recovery suggestions
- **Mock data providers** for SwiftUI Previews and offline testing
- **Request/response logging** for debugging
- **Type-safe API models** with Codable support
- **Rate limiting** and retry logic

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SwiftUI Views │    │  API Services   │    │  Network Layer  │
│                 │◄──►│                 │◄──►│                 │
│ - JobListView   │    │ - JobService    │    │ - URLSession    │
│ - ProfileView   │    │ - AuthService   │    │ - TokenManager  │
│ - BookingView   │    │ - UserService   │    │ - Environment   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │  Domain Models  │
                       │                 │
                       │ - User          │
                       │ - Job           │
                       │ - Application   │
                       │ - Booking       │
                       │ - Review        │
                       │ - Payment       │
                       └─────────────────┘
```

## Domain Models

The API client includes comprehensive domain models translated from the API documentation:

### Core Models
- **User**: User profile and authentication data
- **Job**: Job postings with requirements and compensation
- **Application**: Job applications with status tracking
- **Booking**: Work booking details and scheduling
- **Review**: Performance reviews and ratings
- **Payment**: Payment processing and tracking

### Supporting Models
- **APIResponse<T>**: Generic response wrapper
- **PaginatedResponse<T>**: Paginated data responses
- **APIError**: Standardized error information
- **Environment**: Environment configuration
- **Authentication**: Login/register requests and responses

## Quick Start

### 1. Basic Setup

```swift
import RiggerShared

// The NetworkLayer is automatically configured on app launch
let jobService = JobService()
let authService = AuthService()
```

### 2. Authentication

```swift
// Login
do {
    let response = try await authService.login(
        email: "user@example.com",
        password: "password"
    )
    print("Logged in as: \(response.user.fullName)")
} catch {
    print("Login failed: \(error)")
}

// Check if user is logged in
if TokenManager.shared.isAuthenticated {
    // User is logged in
}

// Logout
authService.logout()
```

### 3. Fetching Data

```swift
// Get jobs with filters
let filters = JobFilters(
    location: "Perth",
    skill: "Advanced Rigging",
    salaryMin: 70000
)

let pagination = PaginationInput(page: 1, limit: 20)

do {
    let response = try await jobService.getJobs(
        filters: filters,
        pagination: pagination
    )
    
    print("Found \(response.pagination.total) jobs")
    for job in response.data {
        print("- \(job.title) at \(job.company)")
    }
} catch {
    print("Error: \(error)")
}
```

### 4. Creating Data

```swift
// Apply to a job
do {
    let application = try await jobService.applyToJob(
        jobId: "job123",
        coverLetter: "I am interested in this position...",
        resumeUrl: "https://example.com/resume.pdf"
    )
    print("Application submitted: \(application.id)")
} catch {
    print("Application failed: \(error)")
}
```

## Environment Configuration

The NetworkLayer supports multiple environments:

```swift
// Switch environments
EnvironmentConfig.shared.switchEnvironment(to: .development)
EnvironmentConfig.shared.switchEnvironment(to: .staging)
EnvironmentConfig.shared.switchEnvironment(to: .production)

// Current environment info
let env = EnvironmentConfig.shared.currentEnvironment
print("Base URL: \(env.baseURL)")
print("Timeout: \(env.timeout)")
print("Debug logging: \(env.isDebugLoggingEnabled)")
```

### Environment URLs
- **Development**: `http://localhost:3000/api/v1`
- **Staging**: `https://staging-api.rigger.sxc.codes/api/v1`
- **Production**: `https://api.rigger.sxc.codes/api/v1`

## Token Management

Tokens are securely stored in the iOS Keychain:

```swift
// Check authentication status
let isLoggedIn = TokenManager.shared.isAuthenticated
let canRefresh = TokenManager.shared.canRefreshToken

// Get current user info
let userId = TokenManager.shared.userId
let userEmail = TokenManager.shared.userEmail

// Clear session
TokenManager.shared.clearSession()
```

### Automatic Token Refresh

The NetworkLayer automatically refreshes expired tokens:

1. API request returns 401 Unauthorized
2. NetworkLayer checks for refresh token
3. Attempts to refresh access token
4. Retries original request with new token
5. If refresh fails, user is logged out

## Error Handling

The NetworkLayer provides comprehensive error handling:

```swift
do {
    let job = try await jobService.getJob(id: "123")
} catch NetworkError.unauthorized {
    // User needs to log in again
    showLoginScreen()
} catch NetworkError.notFound {
    // Job was not found
    showNotFoundMessage()
} catch NetworkError.rateLimited {
    // Too many requests
    showRateLimitMessage()
} catch NetworkError.validationError(let apiError) {
    // Validation failed
    showValidationErrors(apiError.details)
} catch NetworkError.networkUnavailable {
    // No internet connection
    showOfflineMode()
} catch {
    // Other errors
    showGenericError(error)
}
```

### Error Types

- `unauthorized`: 401 - Authentication required
- `forbidden`: 403 - Access denied
- `notFound`: 404 - Resource not found
- `rateLimited`: 429 - Too many requests
- `validationError`: 422 - Invalid input data
- `serverError`: 500+ - Server-side issues
- `networkUnavailable`: No internet connection
- `decodingError`: JSON parsing failed

## Mock Data for Testing

For SwiftUI Previews and testing, use mock data:

```swift
// Create service with mock data
let mockJobService = JobService(useMockData: true)

// Use in SwiftUI Previews
struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        JobListView()
            .onAppear {
                PreviewHelpers.setupMockEnvironment()
            }
    }
}
```

### Available Mock Data

- **3 Mock Users**: Worker, Employer, Admin roles
- **3 Mock Jobs**: Various positions and locations
- **2 Mock Applications**: Different statuses
- **1 Mock Booking**: Complete booking details
- **1 Mock Review**: 5-star review example
- **1 Mock Payment**: Completed payment

## API Services

### AuthService
- `login(email:password:)` - User authentication
- `register(email:password:firstName:lastName:)` - User registration
- `logout()` - Clear user session
- `refreshToken()` - Refresh access token

### JobService
- `getJobs(filters:pagination:)` - Search jobs
- `getJob(id:)` - Get job details
- `createJob(_:)` - Create job posting
- `applyToJob(jobId:coverLetter:resumeUrl:)` - Apply to job

### UserService
- `getUserProfile()` - Get current user profile
- `updateUserProfile(firstName:lastName:bio:)` - Update profile

### ApplicationService
- `getUserApplications()` - Get user's applications
- `getJobApplications(jobId:)` - Get applications for job
- `updateApplicationStatus(applicationId:status:)` - Update status
- `getApplicationAnalytics()` - Get analytics data

### BookingService
- `getBookings(filters:pagination:)` - Get bookings
- `getBooking(id:)` - Get booking details
- `createBooking(_:)` - Create new booking
- `updateBookingStatus(bookingId:status:notes:)` - Update status

### ReviewService
- `getReviews(filters:pagination:)` - Get reviews
- `createReview(_:)` - Create review
- `updateReview(reviewId:request:)` - Update review
- `getReviewAnalytics(for:)` - Get review analytics
- `createReviewResponse(_:)` - Respond to review

### PaymentService
- `getPayments(filters:pagination:)` - Get payments
- `createPayment(_:)` - Create payment
- `updatePaymentStatus(paymentId:status:referenceNumber:)` - Update status
- `getPaymentAnalytics()` - Get payment analytics

## Best Practices

### 1. Use Services, Not NetworkLayer Directly

```swift
// Good ✅
let jobService = JobService()
let jobs = try await jobService.getJobs()

// Avoid ❌
let networkLayer = NetworkLayer.shared
let jobs = try await networkLayer.request(...)
```

### 2. Handle Errors Appropriately

```swift
// Good ✅
do {
    let user = try await userService.getUserProfile()
    updateUI(with: user)
} catch NetworkError.unauthorized {
    showLoginScreen()
} catch NetworkError.networkUnavailable {
    showOfflineMessage()
} catch {
    showErrorAlert(error.localizedDescription)
}

// Avoid ❌
let user = try! await userService.getUserProfile() // Crashes on error
```

### 3. Use Mock Data for Previews

```swift
// Good ✅
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(JobService(useMockData: true))
    }
}
```

### 4. Configure Environment Early

```swift
// In AppDelegate or App struct
override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    #if DEBUG
    EnvironmentConfig.shared.switchEnvironment(to: .development)
    #else
    EnvironmentConfig.shared.switchEnvironment(to: .production)
    #endif
    
    return true
}
```

## Security Considerations

1. **Keychain Storage**: All tokens are stored securely in iOS Keychain
2. **TLS/HTTPS**: All production traffic uses HTTPS
3. **Token Refresh**: Automatic token refresh prevents session hijacking
4. **Request Validation**: All requests include proper headers and validation
5. **Error Handling**: Sensitive information is not exposed in error messages

## Performance Optimizations

1. **Connection Pooling**: URLSession manages connection reuse
2. **Request Timeout**: Configurable timeouts per environment
3. **Retry Logic**: Automatic retry for network failures
4. **Compression**: Automatic request/response compression
5. **Caching**: URLSession handles HTTP caching headers

## Troubleshooting

### Common Issues

1. **401 Unauthorized**
   - Check if user is logged in
   - Verify token hasn't expired
   - Try refreshing the token

2. **Network Timeout**
   - Check internet connection
   - Verify API server is running
   - Increase timeout in environment config

3. **JSON Parsing Errors**
   - Check API response format
   - Verify model definitions match API
   - Enable debug logging to see raw responses

4. **Keychain Access Denied**
   - Check app capabilities
   - Verify device passcode is set
   - Try clearing keychain data

### Debug Logging

Enable debug logging in development:

```swift
// Debug logging is automatically enabled in development environment
EnvironmentConfig.shared.switchEnvironment(to: .development)

// Manual control
if EnvironmentConfig.shared.isDebugLoggingEnabled {
    print("Debug logging is enabled")
}
```

## Contributing

When adding new API endpoints:

1. Add the endpoint to `APIEndpoint` extensions
2. Create request/response models in appropriate files
3. Add service methods to relevant service classes
4. Add mock data to `MockDataProvider`
5. Update documentation and examples

## License

This networking layer is part of the RiggerConnect iOS application.

**Created by ChaseWhiteRabbit NGO**  
**Licensed under GPL v3**

---

For questions or support, contact:
- **Primary**: tiatheone@protonmail.com
- **Technical**: garrett@sxc.codes

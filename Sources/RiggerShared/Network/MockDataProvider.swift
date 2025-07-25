//
//  MockDataProvider.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Mock Data Provider

public final class MockDataProvider {
    public static let shared = MockDataProvider()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Mock Users
    
    public static let mockUsers: [User] = [
        User(
            id: "user1",
            email: "john.rigger@example.com",
            firstName: "John",
            lastName: "Smith",
            role: .user,
            profile: UserProfile(
                bio: "Experienced rigger with 15+ years in mining and construction.",
                skills: ["Advanced Rigging", "Crane Operation", "Safety Management"],
                certifications: ["Advanced Rigging", "Dogger", "White Card"],
                experience: 15,
                location: "Perth, WA",
                avatarUrl: "https://example.com/avatars/john.jpg"
            )
        ),
        User(
            id: "employer1",
            email: "sarah.manager@mining.com",
            firstName: "Sarah",
            lastName: "Johnson",
            role: .employer,
            profile: UserProfile(
                bio: "Senior Project Manager at Perth Mining Corp.",
                skills: ["Project Management", "Team Leadership"],
                certifications: ["Project Management", "Safety Officer"],
                experience: 10,
                location: "Perth, WA",
                avatarUrl: "https://example.com/avatars/sarah.jpg"
            )
        ),
        User(
            id: "user2",
            email: "mike.crane@example.com",
            firstName: "Mike",
            lastName: "Wilson",
            role: .user,
            profile: UserProfile(
                bio: "Certified crane operator and rigger specializing in heavy machinery.",
                skills: ["Crane Operation", "Heavy Lifting", "Site Coordination"],
                certifications: ["Crane Operator", "Advanced Rigging", "HR License"],
                experience: 8,
                location: "Kalgoorlie, WA",
                avatarUrl: "https://example.com/avatars/mike.jpg"
            )
        )
    ]
    
    // MARK: - Mock Jobs
    
    public static let mockJobs: [Job] = [
        Job(
            id: "job1",
            title: "Senior Rigger - Gold Mine Site",
            company: "Perth Mining Corp",
            description: "We are seeking an experienced senior rigger for our gold mining operation in Kalgoorlie. The role involves complex rigging operations, equipment maintenance, and mentoring junior staff.",
            requirements: [
                "5+ years experience in mining rigging",
                "Advanced Rigging certification",
                "Working at Heights certification",
                "Current medical and drug & alcohol clearance"
            ],
            skills: ["Advanced Rigging", "Heavy Lifting", "Equipment Maintenance"],
            location: "Kalgoorlie, WA",
            salary: 95000,
            salaryRange: SalaryRange(min: 85000, max: 105000),
            employerId: "employer1",
            status: .active,
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
        ),
        Job(
            id: "job2",
            title: "Crane Operator & Rigger",
            company: "Industrial Solutions WA",
            description: "Multi-skilled position combining crane operation and rigging duties for infrastructure projects across Perth metropolitan area.",
            requirements: [
                "Crane Operator license",
                "Intermediate Rigging certification",
                "Clean driving record",
                "Flexible with travel"
            ],
            skills: ["Crane Operation", "Rigging", "Mobile Equipment"],
            location: "Perth, WA",
            salary: 78000,
            salaryRange: SalaryRange(min: 72000, max: 85000),
            employerId: "employer1",
            status: .active,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        ),
        Job(
            id: "job3",
            title: "Emergency Rigger - Shutdown",
            company: "Port Hedland Operations",
            description: "Urgent requirement for experienced rigger for planned shutdown at iron ore facility. Accommodation and travel provided.",
            requirements: [
                "Immediate availability",
                "Advanced Rigging certification",
                "Confined Space entry",
                "Experience with conveyor systems"
            ],
            skills: ["Emergency Response", "Shutdown Work", "Conveyor Systems"],
            location: "Port Hedland, WA",
            salary: 120000,
            employerId: "employer1",
            status: .active,
            createdAt: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date()
        )
    ]
    
    // MARK: - Mock Applications
    
    public static let mockApplications: [Application] = [
        Application(
            id: "app1",
            jobId: "job1",
            applicantId: "user1",
            coverLetter: "I am very interested in this senior rigger position. With over 15 years of experience in mining operations, I believe I would be a valuable addition to your team.",
            resumeUrl: "https://example.com/resumes/john_smith.pdf",
            status: .reviewed,
            appliedAt: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            job: mockJobs.first { $0.id == "job1" },
            applicant: mockUsers.first { $0.id == "user1" }
        ),
        Application(
            id: "app2",
            jobId: "job2",
            applicantId: "user2",
            coverLetter: "As a certified crane operator with 8 years of rigging experience, I am excited about this opportunity to work on infrastructure projects.",
            status: .pending,
            appliedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            job: mockJobs.first { $0.id == "job2" },
            applicant: mockUsers.first { $0.id == "user2" }
        )
    ]
    
    // MARK: - Mock Bookings
    
    public static let mockBookings: [Booking] = [
        Booking(
            id: "booking1",
            jobId: "job1",
            workerId: "user1",
            businessId: "employer1",
            applicationId: "app1",
            bookingDetails: BookingDetails(
                startDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 21, to: Date()) ?? Date(),
                workHours: WorkHours(
                    startTime: "06:00",
                    endTime: "18:00",
                    totalHours: 12.0,
                    breakDuration: 60
                ),
                location: WorkLocation(
                    siteName: "Goldmine Site 1",
                    address: "Mining Lease 123, Kalgoorlie WA 6430",
                    coordinates: LocationCoordinates(latitude: -30.7494, longitude: 121.4656),
                    accessInstructions: "Report to main gate security office with photo ID",
                    parkingInfo: "Designated parking area B2"
                ),
                contactInfo: ContactInfo(
                    supervisorName: "Dave Brown",
                    supervisorPhone: "+61 8 9555 0123",
                    supervisorEmail: "dave.brown@mining.com",
                    emergencyContact: EmergencyContact(
                        name: "Site Emergency",
                        phone: "+61 8 9555 0000",
                        relationship: "Site Emergency Services"
                    ),
                    siteOfficePhone: "+61 8 9555 0100"
                ),
                safetyRequirements: [
                    "Full PPE required at all times",
                    "Gas monitoring device mandatory",
                    "Pre-start safety briefing attendance"
                ],
                breakSchedule: BreakSchedule(
                    morningBreak: Break(startTime: "09:30", duration: 15),
                    lunchBreak: Break(startTime: "12:00", duration: 45),
                    afternoonBreak: Break(startTime: "15:30", duration: 15)
                )
            ),
            status: .confirmed,
            confirmedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        )
    ]
    
    // MARK: - Mock Reviews
    
    public static let mockReviews: [Review] = [
        Review(
            id: "review1",
            bookingId: "booking1",
            reviewerId: "employer1",
            revieweeId: "user1",
            reviewType: .businessToWorker,
            rating: 5,
            title: "Exceptional Performance",
            comment: "John exceeded all expectations. His technical expertise and safety awareness were outstanding. Would definitely hire again.",
            categories: ReviewCategories(
                communication: 5,
                professionalism: 5,
                reliability: 5,
                quality: 5,
                safety: 5,
                timeliness: 5
            ),
            status: .approved,
            isPublic: true,
            isVerified: true,
            reviewer: mockUsers.first { $0.id == "employer1" },
            reviewee: mockUsers.first { $0.id == "user1" }
        )
    ]
    
    // MARK: - Mock Payments
    
    public static let mockPayments: [Payment] = [
        Payment(
            id: "payment1",
            jobId: "job1",
            payerId: "employer1",
            payeeId: "user1",
            amount: 15000.00,
            currency: "AUD",
            paymentMethod: .bankTransfer,
            referenceNumber: "PAY-20250126-001",
            notes: "Payment for 2-week booking period",
            status: .completed,
            job: mockJobs.first { $0.id == "job1" },
            payer: mockUsers.first { $0.id == "employer1" },
            payee: mockUsers.first { $0.id == "user1" }
        )
    ]
    
    // MARK: - Mock API Responses
    
    public func getMockJobs(
        filters: JobFilters? = nil,
        pagination: PaginationInput = PaginationInput()
    ) -> PaginatedResponse<Job> {
        var jobs = Self.mockJobs
        
        // Apply filters
        if let filters = filters {
            if let location = filters.location {
                jobs = jobs.filter { $0.location.localizedCaseInsensitiveContains(location) }
            }
            if let skill = filters.skill {
                jobs = jobs.filter { job in
                    job.skills.contains { $0.localizedCaseInsensitiveContains(skill) }
                }
            }
            if let salaryMin = filters.salaryMin {
                jobs = jobs.filter { ($0.salary ?? 0) >= salaryMin }
            }
            if let salaryMax = filters.salaryMax {
                jobs = jobs.filter { ($0.salary ?? Double.greatestFiniteMagnitude) <= salaryMax }
            }
            if let searchTerm = filters.searchTerm {
                jobs = jobs.filter { job in
                    job.title.localizedCaseInsensitiveContains(searchTerm) ||
                    job.description.localizedCaseInsensitiveContains(searchTerm) ||
                    job.company.localizedCaseInsensitiveContains(searchTerm)
                }
            }
        }
        
        // Apply pagination
        let startIndex = (pagination.page - 1) * pagination.limit
        let endIndex = min(startIndex + pagination.limit, jobs.count)
        let paginatedJobs = Array(jobs[startIndex..<endIndex])
        
        let paginationInfo = PaginationInfo(
            page: pagination.page,
            limit: pagination.limit,
            total: jobs.count,
            pages: Int(ceil(Double(jobs.count) / Double(pagination.limit)))
        )
        
        return PaginatedResponse(data: paginatedJobs, pagination: paginationInfo)
    }
    
    public func getMockApplications(for userId: String) -> [Application] {
        return Self.mockApplications.filter { $0.applicantId == userId }
    }
    
    public func getMockBookings(for userId: String) -> [Booking] {
        return Self.mockBookings.filter { $0.workerId == userId || $0.businessId == userId }
    }
    
    public func getMockReviews(for userId: String) -> [Review] {
        return Self.mockReviews.filter { $0.revieweeId == userId || $0.reviewerId == userId }
    }
    
    public func getMockPayments(for userId: String) -> [Payment] {
        return Self.mockPayments.filter { $0.payeeId == userId || $0.payerId == userId }
    }
    
    // MARK: - Mock Authentication
    
    public func getMockAuthResponse() -> AuthResponse {
        return AuthResponse(
            token: "mock_access_token_\(UUID().uuidString)",
            user: Self.mockUsers[0]
        )
    }
    
    // MARK: - Delay Simulation
    
    public func simulateNetworkDelay() async {
        let delay = Double.random(in: 0.5...2.0) // Random delay between 0.5-2 seconds
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
}

// MARK: - Mock Network Layer

public final class MockNetworkLayer: NetworkLayer {
    private let mockProvider = MockDataProvider.shared
    
    public override func request<T: Codable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        requiresAuth: Bool = true
    ) async throws -> T {
        
        // Simulate network delay
        await mockProvider.simulateNetworkDelay()
        
        // Route to appropriate mock response based on endpoint
        switch endpoint.path {
        case "auth/login":
            guard let response = mockProvider.getMockAuthResponse() as? T else {
                throw NetworkError.invalidResponse
            }
            return response
            
        case "jobs":
            let filters = endpoint.queryParameters.isEmpty ? nil : JobFilters(
                location: endpoint.queryParameters["location"],
                skill: endpoint.queryParameters["skill"],
                salaryMin: endpoint.queryParameters["salary_min"].flatMap(Double.init),
                salaryMax: endpoint.queryParameters["salary_max"].flatMap(Double.init),
                searchTerm: endpoint.queryParameters["search"]
            )
            let pagination = PaginationInput(
                page: Int(endpoint.queryParameters["page"] ?? "1") ?? 1,
                limit: Int(endpoint.queryParameters["limit"] ?? "10") ?? 10
            )
            guard let response = mockProvider.getMockJobs(filters: filters, pagination: pagination) as? T else {
                throw NetworkError.invalidResponse
            }
            return response
            
        case let path where path.hasPrefix("jobs/") && path.hasSuffix("/apply"):
            let applicationId = "mock_app_\(UUID().uuidString)"
            let application = Application(
                id: applicationId,
                jobId: String(path.dropFirst(5).dropLast(6)), // Extract job ID
                applicantId: TokenManager.shared.userId ?? "user1",
                status: .pending
            )
            guard let response = application as? T else {
                throw NetworkError.invalidResponse
            }
            return response
            
        case "applications/user":
            let userId = TokenManager.shared.userId ?? "user1"
            guard let response = mockProvider.getMockApplications(for: userId) as? T else {
                throw NetworkError.invalidResponse
            }
            return response
            
        default:
            throw NetworkError.notFound
        }
    }
}

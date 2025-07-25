//
//  ApplicationModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Application Models

public struct Application: Codable, Identifiable, Hashable {
    public let id: String
    public let jobId: String
    public let applicantId: String
    public let coverLetter: String?
    public let resumeUrl: String?
    public let status: ApplicationStatus
    public let createdAt: Date
    public let updatedAt: Date
    public let appliedAt: Date
    
    // Optional related data that may be included in API responses
    public let job: Job?
    public let applicant: User?
    
    public init(
        id: String,
        jobId: String,
        applicantId: String,
        coverLetter: String? = nil,
        resumeUrl: String? = nil,
        status: ApplicationStatus = .pending,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        appliedAt: Date = Date(),
        job: Job? = nil,
        applicant: User? = nil
    ) {
        self.id = id
        self.jobId = jobId
        self.applicantId = applicantId
        self.coverLetter = coverLetter
        self.resumeUrl = resumeUrl
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.appliedAt = appliedAt
        self.job = job
        self.applicant = applicant
    }
}

public enum ApplicationStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case reviewed = "reviewed"
    case accepted = "accepted"
    case rejected = "rejected"
    case withdrawn = "withdrawn"
    
    public var displayName: String {
        switch self {
        case .pending: return "Pending Review"
        case .reviewed: return "Under Review"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        case .withdrawn: return "Withdrawn"
        }
    }
    
    public var color: String {
        switch self {
        case .pending: return "orange"
        case .reviewed: return "blue"
        case .accepted: return "green"
        case .rejected: return "red"
        case .withdrawn: return "gray"
        }
    }
}

// MARK: - Application Request Models

public struct CreateApplicationRequest: Codable {
    public let jobId: String
    public let coverLetter: String?
    public let resumeUrl: String?
    
    public init(jobId: String, coverLetter: String? = nil, resumeUrl: String? = nil) {
        self.jobId = jobId
        self.coverLetter = coverLetter
        self.resumeUrl = resumeUrl
    }
}

public struct UpdateApplicationStatusRequest: Codable {
    public let status: ApplicationStatus
    
    public init(status: ApplicationStatus) {
        self.status = status
    }
}

// MARK: - Application Filter Models

public struct ApplicationFilters: Codable {
    public let status: ApplicationStatus?
    public let jobType: String?
    public let dateFrom: Date?
    public let dateTo: Date?
    public let searchTerm: String?
    
    public init(
        status: ApplicationStatus? = nil,
        jobType: String? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil,
        searchTerm: String? = nil
    ) {
        self.status = status
        self.jobType = jobType
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.searchTerm = searchTerm
    }
}

// MARK: - Application Analytics Models

public struct ApplicationAnalytics: Codable {
    public let totalApplications: Int
    public let pendingApplications: Int
    public let reviewedApplications: Int
    public let acceptedApplications: Int
    public let rejectedApplications: Int
    public let acceptanceRate: Double
    public let averageResponseTime: TimeInterval?
    
    public init(
        totalApplications: Int,
        pendingApplications: Int,
        reviewedApplications: Int,
        acceptedApplications: Int,
        rejectedApplications: Int,
        acceptanceRate: Double,
        averageResponseTime: TimeInterval? = nil
    ) {
        self.totalApplications = totalApplications
        self.pendingApplications = pendingApplications
        self.reviewedApplications = reviewedApplications
        self.acceptedApplications = acceptedApplications
        self.rejectedApplications = rejectedApplications
        self.acceptanceRate = acceptanceRate
        self.averageResponseTime = averageResponseTime
    }
}

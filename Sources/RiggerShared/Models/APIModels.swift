//
//  APIModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - API Response Models

public struct APIResponse<T: Codable>: Codable {
    public let success: Bool
    public let data: T?
    public let error: APIError?
    
    public init(success: Bool, data: T? = nil, error: APIError? = nil) {
        self.success = success
        self.data = data
        self.error = error
    }
}

public struct APIError: Codable, Error {
    public let code: String
    public let message: String
    public let details: [APIErrorDetail]?
    
    public init(code: String, message: String, details: [APIErrorDetail]? = nil) {
        self.code = code
        self.message = message
        self.details = details
    }
}

public struct APIErrorDetail: Codable {
    public let field: String
    public let message: String
    
    public init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}

// MARK: - User API Models (from API docs)

public struct User: Codable, Identifiable, Hashable {
    public let id: String
    public let email: String
    public let firstName: String?
    public let lastName: String?
    public let role: UserRole
    public let profile: UserProfile?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String,
        email: String,
        firstName: String? = nil,
        lastName: String? = nil,
        role: UserRole,
        profile: UserProfile? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.profile = profile
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var fullName: String {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else {
            return email
        }
    }
}

public enum UserRole: String, CaseIterable, Codable {
    case user = "user"
    case employer = "employer"
    case admin = "admin"
    
    public var displayName: String {
        switch self {
        case .user: return "Worker"
        case .employer: return "Employer"
        case .admin: return "Administrator"
        }
    }
}

public struct UserProfile: Codable, Hashable {
    public let bio: String?
    public let skills: [String]
    public let certifications: [String]
    public let experience: Int?
    public let location: String?
    public let avatarUrl: String?
    
    public init(
        bio: String? = nil,
        skills: [String] = [],
        certifications: [String] = [],
        experience: Int? = nil,
        location: String? = nil,
        avatarUrl: String? = nil
    ) {
        self.bio = bio
        self.skills = skills
        self.certifications = certifications
        self.experience = experience
        self.location = location
        self.avatarUrl = avatarUrl
    }
}

// MARK: - Job API Models (from API docs)

public struct Job: Codable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let company: String
    public let description: String
    public let requirements: [String]
    public let skills: [String]
    public let location: String
    public let salary: Double?
    public let salaryRange: SalaryRange?
    public let employerId: String
    public let status: JobStatus
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String,
        title: String,
        company: String,
        description: String,
        requirements: [String] = [],
        skills: [String] = [],
        location: String,
        salary: Double? = nil,
        salaryRange: SalaryRange? = nil,
        employerId: String,
        status: JobStatus = .open,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.company = company
        self.description = description
        self.requirements = requirements
        self.skills = skills
        self.location = location
        self.salary = salary
        self.salaryRange = salaryRange
        self.employerId = employerId
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct SalaryRange: Codable, Hashable {
    public let min: Double
    public let max: Double
    
    public init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
}


// MARK: - Authentication Models

public struct LoginRequest: Codable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct RegisterRequest: Codable {
    public let email: String
    public let password: String
    public let firstName: String
    public let lastName: String
    
    public init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}

public struct AuthResponse: Codable {
    public let token: String
    public let user: User
    
    public init(token: String, user: User) {
        self.token = token
        self.user = user
    }
}

// MARK: - Pagination Models

public struct PaginatedResponse<T: Codable>: Codable {
    public let data: [T]
    public let pagination: PaginationInfo
    
    public init(data: [T], pagination: PaginationInfo) {
        self.data = data
        self.pagination = pagination
    }
}

public struct PaginationInfo: Codable {
    public let page: Int
    public let limit: Int
    public let total: Int
    public let pages: Int
    
    public init(page: Int, limit: Int, total: Int, pages: Int) {
        self.page = page
        self.limit = limit
        self.total = total
        self.pages = pages
    }
}

public struct PaginationInput: Codable {
    public let page: Int
    public let limit: Int
    
    public init(page: Int = 1, limit: Int = 10) {
        self.page = page
        self.limit = limit
    }
}

// MARK: - Job Filter Models

public struct JobFilters: Codable {
    public let location: String?
    public let skill: String?
    public let salaryMin: Double?
    public let salaryMax: Double?
    public let searchTerm: String?
    
    public init(
        location: String? = nil,
        skill: String? = nil,
        salaryMin: Double? = nil,
        salaryMax: Double? = nil,
        searchTerm: String? = nil
    ) {
        self.location = location
        self.skill = skill
        self.salaryMin = salaryMin
        self.salaryMax = salaryMax
        self.searchTerm = searchTerm
    }
}

// MARK: - Job Request Models

public struct CreateJobRequest: Codable {
    public let title: String
    public let company: String
    public let location: String
    public let salary: Double?
    public let description: String
    public let requirements: [String]
    public let skills: [String]
    
    public init(
        title: String,
        company: String,
        location: String,
        salary: Double? = nil,
        description: String,
        requirements: [String] = [],
        skills: [String] = []
    ) {
        self.title = title
        self.company = company
        self.location = location
        self.salary = salary
        self.description = description
        self.requirements = requirements
        self.skills = skills
    }
}

public struct UpdateUserProfileRequest: Codable {
    public let firstName: String?
    public let lastName: String?
    public let bio: String?
    
    public init(firstName: String? = nil, lastName: String? = nil, bio: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
    }
}

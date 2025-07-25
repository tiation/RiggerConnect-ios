//
//  ReviewModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Review Models

public struct Review: Codable, Identifiable, Hashable {
    public let id: String
    public let bookingId: String
    public let reviewerId: String
    public let revieweeId: String
    public let reviewType: ReviewType
    public let rating: Int // 1-5 stars
    public let title: String?
    public let comment: String?
    public let categories: ReviewCategories
    public let status: ReviewStatus
    public let createdAt: Date
    public let updatedAt: Date
    public let isPublic: Bool
    public let isVerified: Bool
    
    // Optional related data
    public let booking: Booking?
    public let reviewer: User?
    public let reviewee: User?
    
    public init(
        id: String,
        bookingId: String,
        reviewerId: String,
        revieweeId: String,
        reviewType: ReviewType,
        rating: Int,
        title: String? = nil,
        comment: String? = nil,
        categories: ReviewCategories,
        status: ReviewStatus = .pending,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isPublic: Bool = true,
        isVerified: Bool = false,
        booking: Booking? = nil,
        reviewer: User? = nil,
        reviewee: User? = nil
    ) {
        self.id = id
        self.bookingId = bookingId
        self.reviewerId = reviewerId
        self.revieweeId = revieweeId
        self.reviewType = reviewType
        self.rating = rating
        self.title = title
        self.comment = comment
        self.categories = categories
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPublic = isPublic
        self.isVerified = isVerified
        self.booking = booking
        self.reviewer = reviewer
        self.reviewee = reviewee
    }
}

public enum ReviewType: String, CaseIterable, Codable {
    case workerToBusiness = "worker_to_business"
    case businessToWorker = "business_to_worker"
    
    public var displayName: String {
        switch self {
        case .workerToBusiness: return "Worker reviewing Business"
        case .businessToWorker: return "Business reviewing Worker"
        }
    }
}

public struct ReviewCategories: Codable, Hashable {
    public let communication: Int?    // 1-5 rating
    public let professionalism: Int?  // 1-5 rating
    public let reliability: Int?      // 1-5 rating
    public let quality: Int?          // 1-5 rating
    public let safety: Int?           // 1-5 rating
    public let timeliness: Int?       // 1-5 rating
    
    public init(
        communication: Int? = nil,
        professionalism: Int? = nil,
        reliability: Int? = nil,
        quality: Int? = nil,
        safety: Int? = nil,
        timeliness: Int? = nil
    ) {
        self.communication = communication
        self.professionalism = professionalism
        self.reliability = reliability
        self.quality = quality
        self.safety = safety
        self.timeliness = timeliness
    }
    
    public var averageRating: Double {
        let ratings = [communication, professionalism, reliability, quality, safety, timeliness].compactMap { $0 }
        guard !ratings.isEmpty else { return 0.0 }
        return Double(ratings.reduce(0, +)) / Double(ratings.count)
    }
}

public enum ReviewStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    case flagged = "flagged"
    
    public var displayName: String {
        switch self {
        case .pending: return "Pending Review"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        case .flagged: return "Flagged for Review"
        }
    }
}

// MARK: - Review Request Models

public struct CreateReviewRequest: Codable {
    public let bookingId: String
    public let revieweeId: String
    public let reviewType: ReviewType
    public let rating: Int
    public let title: String?
    public let comment: String?
    public let categories: ReviewCategories
    public let isPublic: Bool
    
    public init(
        bookingId: String,
        revieweeId: String,
        reviewType: ReviewType,
        rating: Int,
        title: String? = nil,
        comment: String? = nil,
        categories: ReviewCategories,
        isPublic: Bool = true
    ) {
        self.bookingId = bookingId
        self.revieweeId = revieweeId
        self.reviewType = reviewType
        self.rating = rating
        self.title = title
        self.comment = comment
        self.categories = categories
        self.isPublic = isPublic
    }
}

public struct UpdateReviewRequest: Codable {
    public let rating: Int?
    public let title: String?
    public let comment: String?
    public let categories: ReviewCategories?
    public let isPublic: Bool?
    
    public init(
        rating: Int? = nil,
        title: String? = nil,
        comment: String? = nil,
        categories: ReviewCategories? = nil,
        isPublic: Bool? = nil
    ) {
        self.rating = rating
        self.title = title
        self.comment = comment
        self.categories = categories
        self.isPublic = isPublic
    }
}

// MARK: - Review Filter Models

public struct ReviewFilters: Codable {
    public let reviewType: ReviewType?
    public let revieweeId: String?
    public let reviewerId: String?
    public let rating: Int?
    public let dateFrom: Date?
    public let dateTo: Date?
    public let status: ReviewStatus?
    public let isPublic: Bool?
    
    public init(
        reviewType: ReviewType? = nil,
        revieweeId: String? = nil,
        reviewerId: String? = nil,
        rating: Int? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil,
        status: ReviewStatus? = nil,
        isPublic: Bool? = nil
    ) {
        self.reviewType = reviewType
        self.revieweeId = revieweeId
        self.reviewerId = reviewerId
        self.rating = rating
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.status = status
        self.isPublic = isPublic
    }
}

// MARK: - Review Analytics Models

public struct ReviewAnalytics: Codable {
    public let totalReviews: Int
    public let averageRating: Double
    public let ratingDistribution: RatingDistribution
    public let categoryAverages: ReviewCategories
    public let recentReviews: [Review]
    
    public init(
        totalReviews: Int,
        averageRating: Double,
        ratingDistribution: RatingDistribution,
        categoryAverages: ReviewCategories,
        recentReviews: [Review] = []
    ) {
        self.totalReviews = totalReviews
        self.averageRating = averageRating
        self.ratingDistribution = ratingDistribution
        self.categoryAverages = categoryAverages
        self.recentReviews = recentReviews
    }
}

public struct RatingDistribution: Codable, Hashable {
    public let oneStar: Int
    public let twoStar: Int
    public let threeStar: Int
    public let fourStar: Int
    public let fiveStar: Int
    
    public init(
        oneStar: Int = 0,
        twoStar: Int = 0,
        threeStar: Int = 0,
        fourStar: Int = 0,
        fiveStar: Int = 0
    ) {
        self.oneStar = oneStar
        self.twoStar = twoStar
        self.threeStar = threeStar
        self.fourStar = fourStar
        self.fiveStar = fiveStar
    }
    
    public var total: Int {
        return oneStar + twoStar + threeStar + fourStar + fiveStar
    }
}

// MARK: - Review Response Model

public struct ReviewResponse: Codable, Identifiable, Hashable {
    public let id: String
    public let reviewId: String
    public let responderId: String
    public let response: String
    public let createdAt: Date
    public let updatedAt: Date
    
    // Optional related data
    public let responder: User?
    
    public init(
        id: String,
        reviewId: String,
        responderId: String,
        response: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        responder: User? = nil
    ) {
        self.id = id
        self.reviewId = reviewId
        self.responderId = responderId
        self.response = response
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.responder = responder
    }
}

public struct CreateReviewResponseRequest: Codable {
    public let reviewId: String
    public let response: String
    
    public init(reviewId: String, response: String) {
        self.reviewId = reviewId
        self.response = response
    }
}

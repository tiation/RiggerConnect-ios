//
//  UserModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Business User Models (RiggerConnect)

public struct BusinessUser: Codable, Identifiable, Hashable {
    public let id: UUID
    public let email: String
    public let businessProfile: BusinessProfile
    public let subscription: SubscriptionDetails
    public let settings: BusinessSettings
    public let verificationStatus: VerificationStatus
    public let createdAt: Date
    public let lastLoginAt: Date?
    public let isActive: Bool
    
    public init(
        id: UUID = UUID(),
        email: String,
        businessProfile: BusinessProfile,
        subscription: SubscriptionDetails,
        settings: BusinessSettings = BusinessSettings(),
        verificationStatus: VerificationStatus = .pending,
        createdAt: Date = Date(),
        lastLoginAt: Date? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.email = email
        self.businessProfile = businessProfile
        self.subscription = subscription
        self.settings = settings
        self.verificationStatus = verificationStatus
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
        self.isActive = isActive
    }
}

public struct BusinessProfile: Codable, Hashable {
    public let companyName: String
    public let abn: String
    public let contactPerson: ContactPerson
    public let address: BusinessAddress
    public let industry: Industry
    public let companySize: CompanySize
    public let description: String?
    public let website: String?
    public let phone: String
    public let logoUrl: String?
    public let licenseNumber: String?
    public let insuranceDetails: InsuranceDetails?
    
    public init(
        companyName: String,
        abn: String,
        contactPerson: ContactPerson,
        address: BusinessAddress,
        industry: Industry,
        companySize: CompanySize,
        description: String? = nil,
        website: String? = nil,
        phone: String,
        logoUrl: String? = nil,
        licenseNumber: String? = nil,
        insuranceDetails: InsuranceDetails? = nil
    ) {
        self.companyName = companyName
        self.abn = abn
        self.contactPerson = contactPerson
        self.address = address
        self.industry = industry
        self.companySize = companySize
        self.description = description
        self.website = website
        self.phone = phone
        self.logoUrl = logoUrl
        self.licenseNumber = licenseNumber
        self.insuranceDetails = insuranceDetails
    }
}

public struct ContactPerson: Codable, Hashable {
    public let firstName: String
    public let lastName: String
    public let position: String
    public let email: String
    public let phone: String
    public let mobile: String?
    
    public init(
        firstName: String,
        lastName: String,
        position: String,
        email: String,
        phone: String,
        mobile: String? = nil
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.email = email
        self.phone = phone
        self.mobile = mobile
    }
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

public struct BusinessAddress: Codable, Hashable {
    public let street: String
    public let city: String
    public let state: String
    public let postcode: String
    public let country: String
    
    public init(
        street: String,
        city: String,
        state: String = "WA",
        postcode: String,
        country: String = "Australia"
    ) {
        self.street = street
        self.city = city
        self.state = state
        self.postcode = postcode
        self.country = country
    }
    
    public var fullAddress: String {
        return "\(street), \(city), \(state) \(postcode), \(country)"
    }
}

public enum Industry: String, CaseIterable, Codable {
    case mining = "mining"
    case construction = "construction"
    case oilAndGas = "oil_and_gas"
    case manufacturing = "manufacturing"
    case infrastructure = "infrastructure"
    case utilities = "utilities"
    case marine = "marine"
    case transport = "transport"
    case engineering = "engineering"
    case maintenance = "maintenance"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .mining: return "Mining"
        case .construction: return "Construction"
        case .oilAndGas: return "Oil & Gas"
        case .manufacturing: return "Manufacturing"
        case .infrastructure: return "Infrastructure"
        case .utilities: return "Utilities"
        case .marine: return "Marine"
        case .transport: return "Transport"
        case .engineering: return "Engineering"
        case .maintenance: return "Maintenance"
        case .other: return "Other"
        }
    }
}

public enum CompanySize: String, CaseIterable, Codable {
    case micro = "micro"           // 1-4 employees
    case small = "small"           // 5-19 employees
    case medium = "medium"         // 20-199 employees
    case large = "large"           // 200-999 employees
    case enterprise = "enterprise" // 1000+ employees
    
    public var displayName: String {
        switch self {
        case .micro: return "Micro (1-4 employees)"
        case .small: return "Small (5-19 employees)"
        case .medium: return "Medium (20-199 employees)"
        case .large: return "Large (200-999 employees)"
        case .enterprise: return "Enterprise (1000+ employees)"
        }
    }
}

public struct InsuranceDetails: Codable, Hashable {
    public let provider: String
    public let policyNumber: String
    public let coverage: InsuranceCoverage
    public let expiryDate: Date
    public let documentUrl: String?
    
    public init(
        provider: String,
        policyNumber: String,
        coverage: InsuranceCoverage,
        expiryDate: Date,
        documentUrl: String? = nil
    ) {
        self.provider = provider
        self.policyNumber = policyNumber
        self.coverage = coverage
        self.expiryDate = expiryDate
        self.documentUrl = documentUrl
    }
}

public enum InsuranceCoverage: String, CaseIterable, Codable {
    case publicLiability = "public_liability"
    case workersCompensation = "workers_compensation"
    case professional = "professional"
    case comprehensive = "comprehensive"
    
    public var displayName: String {
        switch self {
        case .publicLiability: return "Public Liability"
        case .workersCompensation: return "Workers Compensation"
        case .professional: return "Professional Indemnity"
        case .comprehensive: return "Comprehensive"
        }
    }
}

public enum VerificationStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case inReview = "in_review"
    case verified = "verified"
    case rejected = "rejected"
    case suspended = "suspended"
    
    public var displayName: String {
        switch self {
        case .pending: return "Pending Verification"
        case .inReview: return "Under Review"
        case .verified: return "Verified"
        case .rejected: return "Rejected"
        case .suspended: return "Suspended"
        }
    }
}

public struct BusinessSettings: Codable, Hashable {
    public let notificationPreferences: BusinessNotificationPreferences
    public let privacySettings: BusinessPrivacySettings
    public let billingSettings: BillingSettings
    
    public init(
        notificationPreferences: BusinessNotificationPreferences = BusinessNotificationPreferences(),
        privacySettings: BusinessPrivacySettings = BusinessPrivacySettings(),
        billingSettings: BillingSettings = BillingSettings()
    ) {
        self.notificationPreferences = notificationPreferences
        self.privacySettings = privacySettings
        self.billingSettings = billingSettings
    }
}

public struct BusinessNotificationPreferences: Codable, Hashable {
    public let emailNotifications: Bool
    public let pushNotifications: Bool
    public let applicationNotifications: Bool
    public let messagingNotifications: Bool
    public let billingNotifications: Bool
    public let marketingEmails: Bool
    
    public init(
        emailNotifications: Bool = true,
        pushNotifications: Bool = true,
        applicationNotifications: Bool = true,
        messagingNotifications: Bool = true,
        billingNotifications: Bool = true,
        marketingEmails: Bool = false
    ) {
        self.emailNotifications = emailNotifications
        self.pushNotifications = pushNotifications
        self.applicationNotifications = applicationNotifications
        self.messagingNotifications = messagingNotifications
        self.billingNotifications = billingNotifications
        self.marketingEmails = marketingEmails
    }
}

public struct BusinessPrivacySettings: Codable, Hashable {
    public let profileVisibility: ProfileVisibility
    public let contactInfoVisible: Bool
    public let jobHistoryVisible: Bool
    public let analyticsEnabled: Bool
    
    public init(
        profileVisibility: ProfileVisibility = .public,
        contactInfoVisible: Bool = true,
        jobHistoryVisible: Bool = true,
        analyticsEnabled: Bool = true
    ) {
        self.profileVisibility = profileVisibility
        self.contactInfoVisible = contactInfoVisible
        self.jobHistoryVisible = jobHistoryVisible
        self.analyticsEnabled = analyticsEnabled
    }
}

public enum ProfileVisibility: String, CaseIterable, Codable {
    case `public` = "public"
    case verified = "verified"
    case `private` = "private"
    
    public var displayName: String {
        switch self {
        case .public: return "Public"
        case .verified: return "Verified Users Only"
        case .private: return "Private"
        }
    }
}

public struct BillingSettings: Codable, Hashable {
    public let autoRenew: Bool
    public let billingEmail: String?
    public let invoiceDelivery: InvoiceDelivery
    public let paymentReminders: Bool
    
    public init(
        autoRenew: Bool = true,
        billingEmail: String? = nil,
        invoiceDelivery: InvoiceDelivery = .email,
        paymentReminders: Bool = true
    ) {
        self.autoRenew = autoRenew
        self.billingEmail = billingEmail
        self.invoiceDelivery = invoiceDelivery
        self.paymentReminders = paymentReminders
    }
}

public enum InvoiceDelivery: String, CaseIterable, Codable {
    case email = "email"
    case post = "post"
    case both = "both"
    
    public var displayName: String {
        switch self {
        case .email: return "Email"
        case .post: return "Post"
        case .both: return "Email & Post"
        }
    }
}

// MARK: - Worker User Models (RiggerHub)

public struct WorkerUser: Codable, Identifiable, Hashable {
    public let id: UUID
    public let email: String
    public let workerProfile: WorkerProfile
    public let experience: WorkerExperience
    public let settings: WorkerSettings
    public let verificationStatus: VerificationStatus
    public let createdAt: Date
    public let lastLoginAt: Date?
    public let isActive: Bool
    
    public init(
        id: UUID = UUID(),
        email: String,
        workerProfile: WorkerProfile,
        experience: WorkerExperience,
        settings: WorkerSettings = WorkerSettings(),
        verificationStatus: VerificationStatus = .pending,
        createdAt: Date = Date(),
        lastLoginAt: Date? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.email = email
        self.workerProfile = workerProfile
        self.experience = experience
        self.settings = settings
        self.verificationStatus = verificationStatus
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
        self.isActive = isActive
    }
}

public struct WorkerProfile: Codable, Hashable {
    public let firstName: String
    public let lastName: String
    public let phone: String
    public let address: WorkerAddress
    public let dateOfBirth: Date
    public let primaryTrade: JobType
    public let secondaryTrades: [JobType]
    public let bio: String?
    public let profileImageUrl: String?
    public let resumeUrl: String?
    public let availability: WorkerAvailability
    public let willingToRelocate: Bool
    public let hasOwnTransport: Bool
    public let hasOwnTools: Bool
    
    public init(
        firstName: String,
        lastName: String,
        phone: String,
        address: WorkerAddress,
        dateOfBirth: Date,
        primaryTrade: JobType,
        secondaryTrades: [JobType] = [],
        bio: String? = nil,
        profileImageUrl: String? = nil,
        resumeUrl: String? = nil,
        availability: WorkerAvailability,
        willingToRelocate: Bool = false,
        hasOwnTransport: Bool = false,
        hasOwnTools: Bool = false
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.primaryTrade = primaryTrade
        self.secondaryTrades = secondaryTrades
        self.bio = bio
        self.profileImageUrl = profileImageUrl
        self.resumeUrl = resumeUrl
        self.availability = availability
        self.willingToRelocate = willingToRelocate
        self.hasOwnTransport = hasOwnTransport
        self.hasOwnTools = hasOwnTools
    }
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

public struct WorkerAddress: Codable, Hashable {
    public let suburb: String
    public let city: String
    public let state: String
    public let postcode: String
    public let country: String
    
    public init(
        suburb: String,
        city: String,
        state: String = "WA",
        postcode: String,
        country: String = "Australia"
    ) {
        self.suburb = suburb
        self.city = city
        self.state = state
        self.postcode = postcode
        self.country = country
    }
    
    public var displayLocation: String {
        return "\(suburb), \(city), \(state)"
    }
}

public enum WorkerAvailability: String, CaseIterable, Codable {
    case available = "available"
    case partiallyAvailable = "partially_available"
    case unavailable = "unavailable"
    case seekingWork = "seeking_work"
    
    public var displayName: String {
        switch self {
        case .available: return "Available"
        case .partiallyAvailable: return "Partially Available"
        case .unavailable: return "Unavailable"
        case .seekingWork: return "Actively Seeking Work"
        }
    }
}

public struct WorkerExperience: Codable, Hashable {
    public let totalYearsExperience: Int
    public let certifications: [WorkerCertification]
    public let workHistory: [WorkExperience]
    public let skills: [String]
    public let specializations: [String]
    public let references: [WorkerReference]
    
    public init(
        totalYearsExperience: Int,
        certifications: [WorkerCertification] = [],
        workHistory: [WorkExperience] = [],
        skills: [String] = [],
        specializations: [String] = [],
        references: [WorkerReference] = []
    ) {
        self.totalYearsExperience = totalYearsExperience
        self.certifications = certifications
        self.workHistory = workHistory
        self.skills = skills
        self.specializations = specializations
        self.references = references
    }
}

public struct WorkerCertification: Codable, Hashable, Identifiable {
    public let id: UUID
    public let type: CertificationType
    public let issuer: String
    public let certificationNumber: String
    public let issuedDate: Date
    public let expiryDate: Date?
    public let documentUrl: String?
    public let isVerified: Bool
    
    public init(
        id: UUID = UUID(),
        type: CertificationType,
        issuer: String,
        certificationNumber: String,
        issuedDate: Date,
        expiryDate: Date? = nil,
        documentUrl: String? = nil,
        isVerified: Bool = false
    ) {
        self.id = id
        self.type = type
        self.issuer = issuer
        self.certificationNumber = certificationNumber
        self.issuedDate = issuedDate
        self.expiryDate = expiryDate
        self.documentUrl = documentUrl
        self.isVerified = isVerified
    }
}

public struct WorkExperience: Codable, Hashable, Identifiable {
    public let id: UUID
    public let companyName: String
    public let position: String
    public let jobType: JobType
    public let startDate: Date
    public let endDate: Date?
    public let isCurrent: Bool
    public let description: String
    public let location: String
    public let supervisor: String?
    public let supervisorPhone: String?
    
    public init(
        id: UUID = UUID(),
        companyName: String,
        position: String,
        jobType: JobType,
        startDate: Date,
        endDate: Date? = nil,
        isCurrent: Bool = false,
        description: String,
        location: String,
        supervisor: String? = nil,
        supervisorPhone: String? = nil
    ) {
        self.id = id
        self.companyName = companyName
        self.position = position
        self.jobType = jobType
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrent = isCurrent
        self.description = description
        self.location = location
        self.supervisor = supervisor
        self.supervisorPhone = supervisorPhone
    }
}

public struct WorkerReference: Codable, Hashable, Identifiable {
    public let id: UUID
    public let name: String
    public let position: String
    public let company: String
    public let phone: String
    public let email: String?
    public let relationship: String
    public let yearsKnown: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        position: String,
        company: String,
        phone: String,
        email: String? = nil,
        relationship: String,
        yearsKnown: Int
    ) {
        self.id = id
        self.name = name
        self.position = position
        self.company = company
        self.phone = phone
        self.email = email
        self.relationship = relationship
        self.yearsKnown = yearsKnown
    }
}

public struct WorkerSettings: Codable, Hashable {
    public let notificationPreferences: WorkerNotificationPreferences
    public let privacySettings: WorkerPrivacySettings
    public let jobPreferences: JobPreferences
    
    public init(
        notificationPreferences: WorkerNotificationPreferences = WorkerNotificationPreferences(),
        privacySettings: WorkerPrivacySettings = WorkerPrivacySettings(),
        jobPreferences: JobPreferences = JobPreferences()
    ) {
        self.notificationPreferences = notificationPreferences
        self.privacySettings = privacySettings
        self.jobPreferences = jobPreferences
    }
}

public struct WorkerNotificationPreferences: Codable, Hashable {
    public let emailNotifications: Bool
    public let pushNotifications: Bool
    public let jobAlerts: Bool
    public let messageNotifications: Bool
    public let applicationUpdates: Bool
    public let marketingEmails: Bool
    
    public init(
        emailNotifications: Bool = true,
        pushNotifications: Bool = true,
        jobAlerts: Bool = true,
        messageNotifications: Bool = true,
        applicationUpdates: Bool = true,
        marketingEmails: Bool = false
    ) {
        self.emailNotifications = emailNotifications
        self.pushNotifications = pushNotifications
        self.jobAlerts = jobAlerts
        self.messageNotifications = messageNotifications
        self.applicationUpdates = applicationUpdates
        self.marketingEmails = marketingEmails
    }
}

public struct WorkerPrivacySettings: Codable, Hashable {
    public let profileVisibility: ProfileVisibility
    public let contactInfoVisible: Bool
    public let workHistoryVisible: Bool
    public let referencesVisible: Bool
    public let analyticsEnabled: Bool
    
    public init(
        profileVisibility: ProfileVisibility = .verified,
        contactInfoVisible: Bool = false,
        workHistoryVisible: Bool = true,
        referencesVisible: Bool = false,
        analyticsEnabled: Bool = true
    ) {
        self.profileVisibility = profileVisibility
        self.contactInfoVisible = contactInfoVisible
        self.workHistoryVisible = workHistoryVisible
        self.referencesVisible = referencesVisible
        self.analyticsEnabled = analyticsEnabled
    }
}

public struct JobPreferences: Codable, Hashable {
    public let preferredJobTypes: [JobType]
    public let preferredLocations: [String]
    public let maxTravelDistance: Int // kilometers
    public let minimumPay: Double?
    public let preferredPayType: PayType?
    public let preferredDuration: [JobDuration]
    public let willingToWorkWeekends: Bool
    public let willingToWorkNights: Bool
    public let requiresAccommodation: Bool
    
    public init(
        preferredJobTypes: [JobType] = [],
        preferredLocations: [String] = [],
        maxTravelDistance: Int = 100,
        minimumPay: Double? = nil,
        preferredPayType: PayType? = nil,
        preferredDuration: [JobDuration] = [],
        willingToWorkWeekends: Bool = true,
        willingToWorkNights: Bool = true,
        requiresAccommodation: Bool = false
    ) {
        self.preferredJobTypes = preferredJobTypes
        self.preferredLocations = preferredLocations
        self.maxTravelDistance = maxTravelDistance
        self.minimumPay = minimumPay
        self.preferredPayType = preferredPayType
        self.preferredDuration = preferredDuration
        self.willingToWorkWeekends = willingToWorkWeekends
        self.willingToWorkNights = willingToWorkNights
        self.requiresAccommodation = requiresAccommodation
    }
}

// MARK: - Subscription Models

public struct SubscriptionDetails: Codable, Hashable {
    public let plan: SubscriptionPlan
    public let status: SubscriptionStatus
    public let startDate: Date
    public let endDate: Date
    public let autoRenew: Bool
    public let paymentMethod: PaymentMethod?
    public let lastPaymentDate: Date?
    public let nextBillingDate: Date?
    
    public init(
        plan: SubscriptionPlan,
        status: SubscriptionStatus,
        startDate: Date = Date(),
        endDate: Date,
        autoRenew: Bool = true,
        paymentMethod: PaymentMethod? = nil,
        lastPaymentDate: Date? = nil,
        nextBillingDate: Date? = nil
    ) {
        self.plan = plan
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.autoRenew = autoRenew
        self.paymentMethod = paymentMethod
        self.lastPaymentDate = lastPaymentDate
        self.nextBillingDate = nextBillingDate
    }
}

public enum SubscriptionPlan: String, CaseIterable, Codable {
    case free = "free"
    case basic = "basic"
    case professional = "professional"
    case enterprise = "enterprise"
    
    public var displayName: String {
        switch self {
        case .free: return "Free"
        case .basic: return "Basic"
        case .professional: return "Professional"
        case .enterprise: return "Enterprise"
        }
    }
    
    public var monthlyPrice: Double {
        switch self {
        case .free: return 0.0
        case .basic: return 49.99
        case .professional: return 149.99
        case .enterprise: return 499.99
        }
    }
}

public enum SubscriptionStatus: String, CaseIterable, Codable {
    case active = "active"
    case cancelled = "cancelled"
    case expired = "expired"
    case suspended = "suspended"
    case trial = "trial"
    
    public var displayName: String {
        switch self {
        case .active: return "Active"
        case .cancelled: return "Cancelled"
        case .expired: return "Expired"
        case .suspended: return "Suspended"
        case .trial: return "Trial"
        }
    }
}


//
//  RiggerModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Job Posting Models

public struct JobPosting: Codable, Identifiable, Hashable {
    public let id: UUID
    public let businessId: UUID
    public let title: String
    public let description: String
    public let jobType: JobType
    public let location: JobLocation
    public let requirements: JobRequirements
    public let compensation: CompensationDetails
    public let duration: JobDuration
    public let urgency: UrgencyLevel
    public let postedDate: Date
    public let startDate: Date
    public let endDate: Date?
    public let status: JobStatus
    public let applicationCount: Int
    public let isActive: Bool
    
    public init(
        id: UUID = UUID(),
        businessId: UUID,
        title: String,
        description: String,
        jobType: JobType,
        location: JobLocation,
        requirements: JobRequirements,
        compensation: CompensationDetails,
        duration: JobDuration,
        urgency: UrgencyLevel,
        postedDate: Date = Date(),
        startDate: Date,
        endDate: Date? = nil,
        status: JobStatus = .open,
        applicationCount: Int = 0,
        isActive: Bool = true
    ) {
        self.id = id
        self.businessId = businessId
        self.title = title
        self.description = description
        self.jobType = jobType
        self.location = location
        self.requirements = requirements
        self.compensation = compensation
        self.duration = duration
        self.urgency = urgency
        self.postedDate = postedDate
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.applicationCount = applicationCount
        self.isActive = isActive
    }
}

public enum JobType: String, CaseIterable, Codable {
    case rigger = "rigger"
    case dogger = "dogger" 
    case craneOperator = "crane_operator"
    case scaffolder = "scaffolder"
    case millwright = "millwright"
    case boilermaker = "boilermaker"
    case welder = "welder"
    case electrician = "electrician"
    case fitter = "fitter"
    case supervisor = "supervisor"
    case safetyOfficer = "safety_officer"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .rigger: return "Rigger"
        case .dogger: return "Dogger"
        case .craneOperator: return "Crane Operator"
        case .scaffolder: return "Scaffolder"
        case .millwright: return "Millwright"
        case .boilermaker: return "Boilermaker"
        case .welder: return "Welder"
        case .electrician: return "Electrician"
        case .fitter: return "Fitter"
        case .supervisor: return "Supervisor"
        case .safetyOfficer: return "Safety Officer"
        case .other: return "Other"
        }
    }
}

public struct JobLocation: Codable, Hashable {
    public let address: String
    public let city: String
    public let state: String
    public let postcode: String
    public let country: String
    public let coordinates: CLLocationCoordinate2D?
    public let siteType: SiteType
    public let accommodation: AccommodationDetails?
    
    public init(
        address: String,
        city: String,
        state: String = "WA",
        postcode: String,
        country: String = "Australia",
        coordinates: CLLocationCoordinate2D? = nil,
        siteType: SiteType,
        accommodation: AccommodationDetails? = nil
    ) {
        self.address = address
        self.city = city
        self.state = state
        self.postcode = postcode
        self.country = country
        self.coordinates = coordinates
        self.siteType = siteType
        self.accommodation = accommodation
    }
}

public enum SiteType: String, CaseIterable, Codable {
    case minesite = "minesite"
    case construction = "construction"
    case industrial = "industrial"
    case oilAndGas = "oil_and_gas"
    case infrastructure = "infrastructure"
    case maintenance = "maintenance"
    case shutdown = "shutdown"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .minesite: return "Mine Site"
        case .construction: return "Construction"
        case .industrial: return "Industrial"
        case .oilAndGas: return "Oil & Gas"
        case .infrastructure: return "Infrastructure"
        case .maintenance: return "Maintenance"
        case .shutdown: return "Shutdown"
        case .other: return "Other"
        }
    }
}

public struct AccommodationDetails: Codable, Hashable {
    public let provided: Bool
    public let type: AccommodationType?
    public let description: String?
    public let costCovered: Bool
    
    public init(
        provided: Bool,
        type: AccommodationType? = nil,
        description: String? = nil,
        costCovered: Bool = false
    ) {
        self.provided = provided
        self.type = type
        self.description = description
        self.costCovered = costCovered
    }
}

public enum AccommodationType: String, CaseIterable, Codable {
    case dongas = "dongas"
    case hotel = "hotel"
    case camp = "camp" 
    case apartment = "apartment"
    case house = "house"
    case other = "other"
}

public struct JobRequirements: Codable, Hashable {
    public let experienceLevel: ExperienceLevel
    public let certifications: [CertificationType]
    public let skills: [String]
    public let physicalRequirements: [String]
    public let securityClearance: SecurityClearanceLevel?
    public let drugAndAlcoholTesting: Bool
    public let medicalRequirements: [String]
    
    public init(
        experienceLevel: ExperienceLevel,
        certifications: [CertificationType] = [],
        skills: [String] = [],
        physicalRequirements: [String] = [],
        securityClearance: SecurityClearanceLevel? = nil,
        drugAndAlcoholTesting: Bool = true,
        medicalRequirements: [String] = []
    ) {
        self.experienceLevel = experienceLevel
        self.certifications = certifications
        self.skills = skills
        self.physicalRequirements = physicalRequirements
        self.securityClearance = securityClearance
        self.drugAndAlcoholTesting = drugAndAlcoholTesting
        self.medicalRequirements = medicalRequirements
    }
}

public enum ExperienceLevel: String, CaseIterable, Codable {
    case entry = "entry"
    case intermediate = "intermediate"
    case experienced = "experienced"
    case senior = "senior"
    case expert = "expert"
    
    public var displayName: String {
        switch self {
        case .entry: return "Entry Level (0-2 years)"
        case .intermediate: return "Intermediate (2-5 years)"
        case .experienced: return "Experienced (5-10 years)"
        case .senior: return "Senior (10+ years)"
        case .expert: return "Expert/Specialist"
        }
    }
}

public enum CertificationType: String, CaseIterable, Codable {
    case riggingBasic = "rigging_basic"
    case riggingAdvanced = "rigging_advanced"
    case riggingIntermediate = "rigging_intermediate"
    case craneOperator = "crane_operator"
    case dogger = "dogger"
    case scaffolding = "scaffolding"
    case firstAid = "first_aid"
    case whiteCard = "white_card"
    case workingAtHeights = "working_at_heights"
    case confinedSpace = "confined_space"
    case forklift = "forklift"
    case hrTruck = "hr_truck"
    case mcTruck = "mc_truck"
    case ewd = "ewd"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .riggingBasic: return "Basic Rigging"
        case .riggingIntermediate: return "Intermediate Rigging"
        case .riggingAdvanced: return "Advanced Rigging"
        case .craneOperator: return "Crane Operator"
        case .dogger: return "Dogger"
        case .scaffolding: return "Scaffolding"
        case .firstAid: return "First Aid"
        case .whiteCard: return "White Card"
        case .workingAtHeights: return "Working at Heights"
        case .confinedSpace: return "Confined Space"
        case .forklift: return "Forklift"
        case .hrTruck: return "HR Truck License"
        case .mcTruck: return "MC Truck License"
        case .ewd: return "EWD (Elevating Work Platform)"
        case .other: return "Other"
        }
    }
}

public enum SecurityClearanceLevel: String, CaseIterable, Codable {
    case none = "none"
    case baseline = "baseline"
    case nv1 = "nv1"
    case nv2 = "nv2"
    case pv = "pv"
    
    public var displayName: String {
        switch self {
        case .none: return "None Required"
        case .baseline: return "Baseline"
        case .nv1: return "NV1"
        case .nv2: return "NV2"  
        case .pv: return "PV"
        }
    }
}

public struct CompensationDetails: Codable, Hashable {
    public let payType: PayType
    public let amount: Double
    public let currency: String
    public let overtime: OvertimeDetails?
    public let allowances: [Allowance]
    public let benefits: [String]
    
    public init(
        payType: PayType,
        amount: Double,
        currency: String = "AUD",
        overtime: OvertimeDetails? = nil,
        allowances: [Allowance] = [],
        benefits: [String] = []
    ) {
        self.payType = payType
        self.amount = amount
        self.currency = currency
        self.overtime = overtime
        self.allowances = allowances
        self.benefits = benefits
    }
}

public enum PayType: String, CaseIterable, Codable {
    case hourly = "hourly"
    case daily = "daily"
    case weekly = "weekly"
    case contract = "contract"
    case salary = "salary"
    
    public var displayName: String {
        switch self {
        case .hourly: return "Per Hour"
        case .daily: return "Per Day"
        case .weekly: return "Per Week"
        case .contract: return "Contract"
        case .salary: return "Salary"
        }
    }
}

public struct OvertimeDetails: Codable, Hashable {
    public let rate: Double
    public let afterHours: Double
    public let weekendRate: Double?
    public let publicHolidayRate: Double?
    
    public init(
        rate: Double,
        afterHours: Double = 8.0,
        weekendRate: Double? = nil,
        publicHolidayRate: Double? = nil
    ) {
        self.rate = rate
        self.afterHours = afterHours
        self.weekendRate = weekendRate
        self.publicHolidayRate = publicHolidayRate
    }
}

public struct Allowance: Codable, Hashable {
    public let type: AllowanceType
    public let amount: Double
    public let description: String?
    
    public init(type: AllowanceType, amount: Double, description: String? = nil) {
        self.type = type
        self.amount = amount
        self.description = description
    }
}

public enum AllowanceType: String, CaseIterable, Codable {
    case travel = "travel"
    case accommodation = "accommodation"
    case meals = "meals"
    case tools = "tools"
    case safety = "safety"
    case remote = "remote"
    case height = "height"
    case confined = "confined"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .travel: return "Travel Allowance"
        case .accommodation: return "Accommodation Allowance"
        case .meals: return "Meals Allowance"
        case .tools: return "Tool Allowance"
        case .safety: return "Safety Allowance"
        case .remote: return "Remote Site Allowance"
        case .height: return "Height Allowance"
        case .confined: return "Confined Space Allowance"
        case .other: return "Other"
        }
    }
}

public enum JobDuration: String, CaseIterable, Codable {
    case shortTerm = "short_term"      // 1 day - 2 weeks
    case mediumTerm = "medium_term"    // 2 weeks - 3 months
    case longTerm = "long_term"        // 3+ months
    case permanent = "permanent"       // Ongoing
    case casual = "casual"             // As needed
    
    public var displayName: String {
        switch self {
        case .shortTerm: return "Short Term (1 day - 2 weeks)"
        case .mediumTerm: return "Medium Term (2 weeks - 3 months)"
        case .longTerm: return "Long Term (3+ months)"
        case .permanent: return "Permanent"
        case .casual: return "Casual/As Needed"
        }
    }
}

public enum UrgencyLevel: String, CaseIterable, Codable {
    case low = "low"
    case normal = "normal"
    case high = "high"
    case urgent = "urgent"
    case critical = "critical"
    
    public var displayName: String {
        switch self {
        case .low: return "Low Priority"
        case .normal: return "Normal"
        case .high: return "High Priority"
        case .urgent: return "Urgent"
        case .critical: return "Critical/Emergency"
        }
    }
}

public enum JobStatus: String, CaseIterable, Codable {
    case draft = "draft"
    case open = "open"
    case inProgress = "in_progress"
    case filled = "filled"
    case cancelled = "cancelled"
    case completed = "completed"
    case expired = "expired"
    
    public var displayName: String {
        switch self {
        case .draft: return "Draft"
        case .open: return "Open"
        case .inProgress: return "In Progress"
        case .filled: return "Filled"
        case .cancelled: return "Cancelled"
        case .completed: return "Completed"
        case .expired: return "Expired"
        }
    }
}

// MARK: - Core Location Extension

import CoreLocation

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

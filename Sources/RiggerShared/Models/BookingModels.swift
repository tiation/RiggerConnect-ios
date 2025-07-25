//
//  BookingModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Booking Models

public struct Booking: Codable, Identifiable, Hashable {
    public let id: String
    public let jobId: String
    public let workerId: String
    public let businessId: String
    public let applicationId: String?
    public let bookingDetails: BookingDetails
    public let status: BookingStatus
    public let createdAt: Date
    public let updatedAt: Date
    public let confirmedAt: Date?
    public let completedAt: Date?
    public let cancelledAt: Date?
    
    // Optional related data
    public let job: Job?
    public let worker: User?
    public let business: User?
    
    public init(
        id: String,
        jobId: String,
        workerId: String,
        businessId: String,
        applicationId: String? = nil,
        bookingDetails: BookingDetails,
        status: BookingStatus = .pending,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        confirmedAt: Date? = nil,
        completedAt: Date? = nil,
        cancelledAt: Date? = nil,
        job: Job? = nil,
        worker: User? = nil,
        business: User? = nil
    ) {
        self.id = id
        self.jobId = jobId
        self.workerId = workerId
        self.businessId = businessId
        self.applicationId = applicationId
        self.bookingDetails = bookingDetails
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.confirmedAt = confirmedAt
        self.completedAt = completedAt
        self.cancelledAt = cancelledAt
        self.job = job
        self.worker = worker
        self.business = business
    }
}

public struct BookingDetails: Codable, Hashable {
    public let startDate: Date
    public let endDate: Date
    public let workHours: WorkHours
    public let location: WorkLocation
    public let equipment: [Equipment]
    public let instructions: String?
    public let contactInfo: ContactInfo
    public let safetyRequirements: [String]
    public let breakSchedule: BreakSchedule?
    
    public init(
        startDate: Date,
        endDate: Date,
        workHours: WorkHours,
        location: WorkLocation,
        equipment: [Equipment] = [],
        instructions: String? = nil,
        contactInfo: ContactInfo,
        safetyRequirements: [String] = [],
        breakSchedule: BreakSchedule? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.workHours = workHours
        self.location = location
        self.equipment = equipment
        self.instructions = instructions
        self.contactInfo = contactInfo
        self.safetyRequirements = safetyRequirements
        self.breakSchedule = breakSchedule
    }
}

public struct WorkHours: Codable, Hashable {
    public let startTime: String // Format: "HH:mm"
    public let endTime: String   // Format: "HH:mm"
    public let totalHours: Double
    public let breakDuration: Int // minutes
    public let overtimeEnabled: Bool
    
    public init(
        startTime: String,
        endTime: String,
        totalHours: Double,
        breakDuration: Int = 60,
        overtimeEnabled: Bool = true
    ) {
        self.startTime = startTime
        self.endTime = endTime
        self.totalHours = totalHours
        self.breakDuration = breakDuration
        self.overtimeEnabled = overtimeEnabled
    }
}

public struct WorkLocation: Codable, Hashable {
    public let siteName: String
    public let address: String
    public let coordinates: LocationCoordinates?
    public let accessInstructions: String?
    public let parkingInfo: String?
    public let accommodation: AccommodationInfo?
    
    public init(
        siteName: String,
        address: String,
        coordinates: LocationCoordinates? = nil,
        accessInstructions: String? = nil,
        parkingInfo: String? = nil,
        accommodation: AccommodationInfo? = nil
    ) {
        self.siteName = siteName
        self.address = address
        self.coordinates = coordinates
        self.accessInstructions = accessInstructions
        self.parkingInfo = parkingInfo
        self.accommodation = accommodation
    }
}

public struct LocationCoordinates: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct AccommodationInfo: Codable, Hashable {
    public let provided: Bool
    public let type: String?
    public let address: String?
    public let checkInTime: String?
    public let checkOutTime: String?
    public let contactNumber: String?
    
    public init(
        provided: Bool,
        type: String? = nil,
        address: String? = nil,
        checkInTime: String? = nil,
        checkOutTime: String? = nil,
        contactNumber: String? = nil
    ) {
        self.provided = provided
        self.type = type
        self.address = address
        self.checkInTime = checkInTime
        self.checkOutTime = checkOutTime
        self.contactNumber = contactNumber
    }
}

public struct Equipment: Codable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let type: EquipmentType
    public let description: String?
    public let providedByClient: Bool
    public let requiresCertification: Bool
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        type: EquipmentType,
        description: String? = nil,
        providedByClient: Bool = true,
        requiresCertification: Bool = false
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.providedByClient = providedByClient
        self.requiresCertification = requiresCertification
    }
}

public enum EquipmentType: String, CaseIterable, Codable {
    case crane = "crane"
    case hoist = "hoist"
    case rigging = "rigging"
    case safety = "safety"
    case tools = "tools"
    case vehicles = "vehicles"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .crane: return "Crane Equipment"
        case .hoist: return "Hoist Equipment"
        case .rigging: return "Rigging Equipment"
        case .safety: return "Safety Equipment"
        case .tools: return "Tools"
        case .vehicles: return "Vehicles"
        case .other: return "Other Equipment"
        }
    }
}

public struct ContactInfo: Codable, Hashable {
    public let supervisorName: String
    public let supervisorPhone: String
    public let supervisorEmail: String?
    public let emergencyContact: EmergencyContact
    public let siteOfficePhone: String?
    
    public init(
        supervisorName: String,
        supervisorPhone: String,
        supervisorEmail: String? = nil,
        emergencyContact: EmergencyContact,
        siteOfficePhone: String? = nil
    ) {
        self.supervisorName = supervisorName
        self.supervisorPhone = supervisorPhone
        self.supervisorEmail = supervisorEmail
        self.emergencyContact = emergencyContact
        self.siteOfficePhone = siteOfficePhone
    }
}

public struct EmergencyContact: Codable, Hashable {
    public let name: String
    public let phone: String
    public let relationship: String
    
    public init(name: String, phone: String, relationship: String) {
        self.name = name
        self.phone = phone
        self.relationship = relationship
    }
}

public struct BreakSchedule: Codable, Hashable {
    public let morningBreak: Break?
    public let lunchBreak: Break
    public let afternoonBreak: Break?
    
    public init(
        morningBreak: Break? = nil,
        lunchBreak: Break,
        afternoonBreak: Break? = nil
    ) {
        self.morningBreak = morningBreak
        self.lunchBreak = lunchBreak
        self.afternoonBreak = afternoonBreak
    }
}

public struct Break: Codable, Hashable {
    public let startTime: String // Format: "HH:mm"
    public let duration: Int      // minutes
    public let paid: Bool
    
    public init(startTime: String, duration: Int, paid: Bool = true) {
        self.startTime = startTime
        self.duration = duration
        self.paid = paid
    }
}

public enum BookingStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case confirmed = "confirmed"
    case inProgress = "in_progress"
    case completed = "completed"
    case cancelled = "cancelled"
    case noShow = "no_show"
    
    public var displayName: String {
        switch self {
        case .pending: return "Pending Confirmation"
        case .confirmed: return "Confirmed"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .noShow: return "No Show"
        }
    }
    
    public var color: String {
        switch self {
        case .pending: return "orange"
        case .confirmed: return "blue"
        case .inProgress: return "green"
        case .completed: return "success"
        case .cancelled: return "red"
        case .noShow: return "warning"
        }
    }
}

// MARK: - Booking Request Models

public struct CreateBookingRequest: Codable {
    public let jobId: String
    public let workerId: String
    public let applicationId: String?
    public let bookingDetails: BookingDetails
    
    public init(
        jobId: String,
        workerId: String,
        applicationId: String? = nil,
        bookingDetails: BookingDetails
    ) {
        self.jobId = jobId
        self.workerId = workerId
        self.applicationId = applicationId
        self.bookingDetails = bookingDetails
    }
}

public struct UpdateBookingStatusRequest: Codable {
    public let status: BookingStatus
    public let notes: String?
    
    public init(status: BookingStatus, notes: String? = nil) {
        self.status = status
        self.notes = notes
    }
}

// MARK: - Booking Filter Models

public struct BookingFilters: Codable {
    public let status: BookingStatus?
    public let dateFrom: Date?
    public let dateTo: Date?
    public let location: String?
    public let workerId: String?
    public let businessId: String?
    
    public init(
        status: BookingStatus? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil,
        location: String? = nil,
        workerId: String? = nil,
        businessId: String? = nil
    ) {
        self.status = status
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.location = location
        self.workerId = workerId
        self.businessId = businessId
    }
}

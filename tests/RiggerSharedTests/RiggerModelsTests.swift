//
//  RiggerModelsTests.swift
//  RiggerConnect iOS Tests
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import XCTest
@testable import RiggerShared
import CoreLocation

final class RiggerModelsTests: XCTestCase {
    
    // MARK: - JobPosting Tests
    
    func testJobPostingCreation() {
        // Given
        let businessId = UUID()
        let location = JobLocation(
            address: "123 Mining Road",
            city: "Karratha",
            postcode: "6714",
            siteType: .minesite
        )
        let requirements = JobRequirements(
            experienceLevel: .experienced,
            certifications: [.riggingAdvanced, .craneOperator]
        )
        let compensation = CompensationDetails(
            payType: .hourly,
            amount: 55.0
        )
        
        // When
        let jobPosting = JobPosting(
            businessId: businessId,
            title: "Experienced Rigger - Mine Site",
            description: "Looking for experienced rigger for mine site work",
            jobType: .rigger,
            location: location,
            requirements: requirements,
            compensation: compensation,
            duration: .longTerm,
            urgency: .normal,
            startDate: Date()
        )
        
        // Then
        XCTAssertEqual(jobPosting.businessId, businessId)
        XCTAssertEqual(jobPosting.title, "Experienced Rigger - Mine Site")
        XCTAssertEqual(jobPosting.jobType, .rigger)
        XCTAssertEqual(jobPosting.location.city, "Karratha")
        XCTAssertEqual(jobPosting.requirements.experienceLevel, .experienced)
        XCTAssertEqual(jobPosting.compensation.payType, .hourly)
        XCTAssertEqual(jobPosting.compensation.amount, 55.0)
        XCTAssertEqual(jobPosting.duration, .longTerm)
        XCTAssertEqual(jobPosting.urgency, .normal)
        XCTAssertEqual(jobPosting.status, .open)
        XCTAssertTrue(jobPosting.isActive)
    }
    
    func testJobTypeDisplayNames() {
        XCTAssertEqual(JobType.rigger.displayName, "Rigger")
        XCTAssertEqual(JobType.dogger.displayName, "Dogger")
        XCTAssertEqual(JobType.craneOperator.displayName, "Crane Operator")
        XCTAssertEqual(JobType.scaffolder.displayName, "Scaffolder")
        XCTAssertEqual(JobType.safetyOfficer.displayName, "Safety Officer")
    }
    
    func testSiteTypeDisplayNames() {
        XCTAssertEqual(SiteType.minesite.displayName, "Mine Site")
        XCTAssertEqual(SiteType.construction.displayName, "Construction")
        XCTAssertEqual(SiteType.oilAndGas.displayName, "Oil & Gas")
        XCTAssertEqual(SiteType.shutdown.displayName, "Shutdown")
    }
    
    func testExperienceLevelDisplayNames() {
        XCTAssertEqual(ExperienceLevel.entry.displayName, "Entry Level (0-2 years)")
        XCTAssertEqual(ExperienceLevel.intermediate.displayName, "Intermediate (2-5 years)")
        XCTAssertEqual(ExperienceLevel.experienced.displayName, "Experienced (5-10 years)")
        XCTAssertEqual(ExperienceLevel.senior.displayName, "Senior (10+ years)")
        XCTAssertEqual(ExperienceLevel.expert.displayName, "Expert/Specialist")
    }
    
    // MARK: - Certification Tests
    
    func testCertificationDisplayNames() {
        XCTAssertEqual(CertificationType.riggingBasic.displayName, "Basic Rigging")
        XCTAssertEqual(CertificationType.riggingAdvanced.displayName, "Advanced Rigging")
        XCTAssertEqual(CertificationType.craneOperator.displayName, "Crane Operator")
        XCTAssertEqual(CertificationType.dogger.displayName, "Dogger")
        XCTAssertEqual(CertificationType.whiteCard.displayName, "White Card")
        XCTAssertEqual(CertificationType.workingAtHeights.displayName, "Working at Heights")
        XCTAssertEqual(CertificationType.confinedSpace.displayName, "Confined Space")
    }
    
    // MARK: - Compensation Tests
    
    func testCompensationDetailsCreation() {
        // Given
        let overtime = OvertimeDetails(rate: 1.5, afterHours: 8.0)
        let allowances = [
            Allowance(type: .travel, amount: 50.0),
            Allowance(type: .accommodation, amount: 120.0)
        ]
        
        // When
        let compensation = CompensationDetails(
            payType: .hourly,
            amount: 45.0,
            overtime: overtime,
            allowances: allowances,
            benefits: ["Health Insurance", "Superannuation"]
        )
        
        // Then
        XCTAssertEqual(compensation.payType, .hourly)
        XCTAssertEqual(compensation.amount, 45.0)
        XCTAssertEqual(compensation.currency, "AUD")
        XCTAssertNotNil(compensation.overtime)
        XCTAssertEqual(compensation.overtime?.rate, 1.5)
        XCTAssertEqual(compensation.allowances.count, 2)
        XCTAssertEqual(compensation.allowances[0].type, .travel)
        XCTAssertEqual(compensation.allowances[1].amount, 120.0)
        XCTAssertEqual(compensation.benefits.count, 2)
    }
    
    func testPayTypeDisplayNames() {
        XCTAssertEqual(PayType.hourly.displayName, "Per Hour")
        XCTAssertEqual(PayType.daily.displayName, "Per Day")
        XCTAssertEqual(PayType.weekly.displayName, "Per Week")
        XCTAssertEqual(PayType.contract.displayName, "Contract")
        XCTAssertEqual(PayType.salary.displayName, "Salary")
    }
    
    func testAllowanceTypeDisplayNames() {
        XCTAssertEqual(AllowanceType.travel.displayName, "Travel Allowance")
        XCTAssertEqual(AllowanceType.accommodation.displayName, "Accommodation Allowance")
        XCTAssertEqual(AllowanceType.meals.displayName, "Meals Allowance")
        XCTAssertEqual(AllowanceType.remote.displayName, "Remote Site Allowance")
        XCTAssertEqual(AllowanceType.height.displayName, "Height Allowance")
    }
    
    // MARK: - Duration and Status Tests
    
    func testJobDurationDisplayNames() {
        XCTAssertEqual(JobDuration.shortTerm.displayName, "Short Term (1 day - 2 weeks)")
        XCTAssertEqual(JobDuration.mediumTerm.displayName, "Medium Term (2 weeks - 3 months)")
        XCTAssertEqual(JobDuration.longTerm.displayName, "Long Term (3+ months)")
        XCTAssertEqual(JobDuration.permanent.displayName, "Permanent")
        XCTAssertEqual(JobDuration.casual.displayName, "Casual/As Needed")
    }
    
    func testUrgencyLevelDisplayNames() {
        XCTAssertEqual(UrgencyLevel.low.displayName, "Low Priority")
        XCTAssertEqual(UrgencyLevel.normal.displayName, "Normal")
        XCTAssertEqual(UrgencyLevel.high.displayName, "High Priority")
        XCTAssertEqual(UrgencyLevel.urgent.displayName, "Urgent")
        XCTAssertEqual(UrgencyLevel.critical.displayName, "Critical/Emergency")
    }
    
    func testJobStatusDisplayNames() {
        XCTAssertEqual(JobStatus.draft.displayName, "Draft")
        XCTAssertEqual(JobStatus.open.displayName, "Open")
        XCTAssertEqual(JobStatus.inProgress.displayName, "In Progress")
        XCTAssertEqual(JobStatus.filled.displayName, "Filled")
        XCTAssertEqual(JobStatus.cancelled.displayName, "Cancelled")
        XCTAssertEqual(JobStatus.completed.displayName, "Completed")
        XCTAssertEqual(JobStatus.expired.displayName, "Expired")
    }
    
    // MARK: - Location Tests
    
    func testJobLocationCreation() {
        // Given
        let coordinates = CLLocationCoordinate2D(latitude: -20.7264, longitude: 116.8432)
        let accommodation = AccommodationDetails(
            provided: true,
            type: .dongas,
            description: "Mining camp accommodation",
            costCovered: true
        )
        
        // When
        let location = JobLocation(
            address: "123 Mining Road",
            city: "Karratha",
            postcode: "6714",
            coordinates: coordinates,
            siteType: .minesite,
            accommodation: accommodation
        )
        
        // Then
        XCTAssertEqual(location.address, "123 Mining Road")
        XCTAssertEqual(location.city, "Karratha")
        XCTAssertEqual(location.state, "WA")
        XCTAssertEqual(location.postcode, "6714")
        XCTAssertEqual(location.country, "Australia")
        XCTAssertEqual(location.siteType, .minesite)
        XCTAssertNotNil(location.coordinates)
        XCTAssertNotNil(location.accommodation)
        XCTAssertTrue(location.accommodation?.provided ?? false)
        XCTAssertEqual(location.accommodation?.type, .dongas)
    }
    
    // MARK: - Codable Tests
    
    func testJobPostingCodable() throws {
        // Given
        let originalJobPosting = createSampleJobPosting()
        
        // When - Encode
        let encoded = try JSONEncoder().encode(originalJobPosting)
        
        // Then - Decode
        let decodedJobPosting = try JSONDecoder().decode(JobPosting.self, from: encoded)
        
        // Verify
        XCTAssertEqual(originalJobPosting.id, decodedJobPosting.id)
        XCTAssertEqual(originalJobPosting.title, decodedJobPosting.title)
        XCTAssertEqual(originalJobPosting.jobType, decodedJobPosting.jobType)
        XCTAssertEqual(originalJobPosting.location.city, decodedJobPosting.location.city)
        XCTAssertEqual(originalJobPosting.requirements.experienceLevel, decodedJobPosting.requirements.experienceLevel)
        XCTAssertEqual(originalJobPosting.compensation.amount, decodedJobPosting.compensation.amount)
        XCTAssertEqual(originalJobPosting.duration, decodedJobPosting.duration)
        XCTAssertEqual(originalJobPosting.status, decodedJobPosting.status)
    }
    
    func testCLLocationCoordinate2DCodable() throws {
        // Given
        let originalCoordinate = CLLocationCoordinate2D(latitude: -20.7264, longitude: 116.8432)
        
        // When - Encode
        let encoded = try JSONEncoder().encode(originalCoordinate)
        
        // Then - Decode
        let decodedCoordinate = try JSONDecoder().decode(CLLocationCoordinate2D.self, from: encoded)
        
        // Verify
        XCTAssertEqual(originalCoordinate.latitude, decodedCoordinate.latitude, accuracy: 0.0001)
        XCTAssertEqual(originalCoordinate.longitude, decodedCoordinate.longitude, accuracy: 0.0001)
    }
    
    // MARK: - Helper Methods
    
    private func createSampleJobPosting() -> JobPosting {
        let location = JobLocation(
            address: "123 Mining Road",
            city: "Karratha",
            postcode: "6714",
            siteType: .minesite
        )
        
        let requirements = JobRequirements(
            experienceLevel: .experienced,
            certifications: [.riggingAdvanced, .craneOperator, .whiteCard],
            drugAndAlcoholTesting: true
        )
        
        let compensation = CompensationDetails(
            payType: .hourly,
            amount: 55.0,
            allowances: [Allowance(type: .remote, amount: 25.0)]
        )
        
        return JobPosting(
            businessId: UUID(),
            title: "Experienced Rigger - Mine Site",
            description: "Looking for experienced rigger for long-term mine site work",
            jobType: .rigger,
            location: location,
            requirements: requirements,
            compensation: compensation,
            duration: .longTerm,
            urgency: .normal,
            startDate: Date()
        )
    }
}

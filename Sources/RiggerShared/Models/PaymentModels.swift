//
//  PaymentModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import Foundation

// MARK: - Payment Models

public struct Payment: Codable, Identifiable, Hashable {
    public let id: String
    public let jobId: String
    public let payerId: String
    public let payeeId: String
    public let amount: Double
    public let currency: String
    public let transactionDate: Date
    public let paymentMethod: PaymentMethod
    public let referenceNumber: String?
    public let notes: String?
    public let status: PaymentStatus
    public let createdAt: Date
    public let updatedAt: Date
    
    // Optional related data
    public let job: Job?
    public let payer: User?
    public let payee: User?
    
    public init(
        id: String,
        jobId: String,
        payerId: String,
        payeeId: String,
        amount: Double,
        currency: String = "AUD",
        transactionDate: Date = Date(),
        paymentMethod: PaymentMethod,
        referenceNumber: String? = nil,
        notes: String? = nil,
        status: PaymentStatus = .pending,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        job: Job? = nil,
        payer: User? = nil,
        payee: User? = nil
    ) {
        self.id = id
        self.jobId = jobId
        self.payerId = payerId
        self.payeeId = payeeId
        self.amount = amount
        self.currency = currency
        self.transactionDate = transactionDate
        self.paymentMethod = paymentMethod
        self.referenceNumber = referenceNumber
        self.notes = notes
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.job = job
        self.payer = payer
        self.payee = payee
    }
}

public enum PaymentMethod: String, CaseIterable, Codable {
    case creditCard = "credit_card"
    case debitCard = "debit_card"
    case bankTransfer = "bank_transfer"
    case paypal = "paypal"
    case cash = "cash"
    case cheque = "cheque"
    
    public var displayName: String {
        switch self {
        case .creditCard: return "Credit Card"
        case .debitCard: return "Debit Card"
        case .bankTransfer: return "Bank Transfer"
        case .paypal: return "PayPal"
        case .cash: return "Cash"
        case .cheque: return "Cheque"
        }
    }
}

public enum PaymentStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case completed = "completed"
    case failed = "failed"
    case refunded = "refunded"
    
    public var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .refunded: return "Refunded"
        }
    }
}

// MARK: - Payment Request Models

public struct CreatePaymentRequest: Codable {
    public let jobId: String
    public let payerId: String
    public let payeeId: String
    public let amount: Double
    public let currency: String
    public let paymentMethod: PaymentMethod
    public let notes: String?
    
    public init(
        jobId: String,
        payerId: String,
        payeeId: String,
        amount: Double,
        currency: String = "AUD",
        paymentMethod: PaymentMethod,
        notes: String? = nil
    ) {
        self.jobId = jobId
        self.payerId = payerId
        self.payeeId = payeeId
        self.amount = amount
        self.currency = currency
        self.paymentMethod = paymentMethod
        self.notes = notes
    }
}

public struct UpdatePaymentStatusRequest: Codable {
    public let status: PaymentStatus
    public let referenceNumber: String?
    
    public init(status: PaymentStatus, referenceNumber: String? = nil) {
        self.status = status
        self.referenceNumber = referenceNumber
    }
}

// MARK: - Payment Filter Models

public struct PaymentFilters: Codable {
    public let status: PaymentStatus?
    public let dateFrom: Date?
    public let dateTo: Date?
    public let currency: String?
    public let paymentMethod: PaymentMethod?
    public let jobId: String?
    
    public init(
        status: PaymentStatus? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil,
        currency: String? = nil,
        paymentMethod: PaymentMethod? = nil,
        jobId: String? = nil
    ) {
        self.status = status
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.currency = currency
        self.paymentMethod = paymentMethod
        self.jobId = jobId
    }
}

// MARK: - Payment Analytics Models

public struct PaymentAnalytics: Codable {
    public let totalPayments: Int
    public let totalValue: Double
    public let completedPayments: Int
    public let pendingPayments: Int
    public let failedPayments: Int
    public let averagePaymentValue: Double
    
    public init(
        totalPayments: Int,
        totalValue: Double,
        completedPayments: Int,
        pendingPayments: Int,
        failedPayments: Int,
        averagePaymentValue: Double
    ) {
        self.totalPayments = totalPayments
        self.totalValue = totalValue
        self.completedPayments = completedPayments
        self.pendingPayments = pendingPayments
        self.failedPayments = failedPayments
        self.averagePaymentValue = averagePaymentValue
    }
}

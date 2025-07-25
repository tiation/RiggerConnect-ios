//
//  ModuleFactory.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import UIKit
import Combine

// MARK: - Base Factory Protocols

protocol ViewFactory {
    associatedtype ViewType: UIViewController
    func createView() -> ViewType
}

protocol ViewModelFactory {
    associatedtype ViewModelType
    func createViewModel() -> ViewModelType
}

protocol CoordinatorFactory {
    associatedtype CoordinatorType
    func createCoordinator(navigationController: UINavigationController) -> CoordinatorType
}

protocol ServiceFactory {
    associatedtype ServiceType
    func createService() -> ServiceType
}

// MARK: - Module-Specific Factory Protocols

// Auth Module
protocol AuthViewFactory: ViewFactory {
    func createLoginView() -> AuthLoginViewController
    func createSignUpView() -> AuthSignUpViewController
    func createForgotPasswordView() -> AuthForgotPasswordViewController
}

protocol AuthViewModelFactory: ViewModelFactory {
    func createLoginViewModel() -> AuthLoginViewModel
    func createSignUpViewModel() -> AuthSignUpViewModel
    func createForgotPasswordViewModel() -> AuthForgotPasswordViewModel
}

protocol AuthCoordinatorFactory: CoordinatorFactory {
    func createAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator
}

// Business Dashboard Module
protocol BusinessDashboardViewFactory: ViewFactory {
    func createDashboardView() -> BusinessDashboardViewController
    func createAnalyticsView() -> BusinessAnalyticsViewController
    func createManagementView() -> BusinessManagementViewController
}

protocol BusinessDashboardViewModelFactory: ViewModelFactory {
    func createDashboardViewModel() -> BusinessDashboardViewModel
    func createAnalyticsViewModel() -> BusinessAnalyticsViewModel
    func createManagementViewModel() -> BusinessManagementViewModel
}

protocol BusinessDashboardCoordinatorFactory: CoordinatorFactory {
    func createBusinessDashboardCoordinator(navigationController: UINavigationController) -> BusinessDashboardCoordinator
}

// Job Post Module
protocol JobPostViewFactory: ViewFactory {
    func createJobPostView() -> JobPostViewController
    func createJobListView() -> JobListViewController
    func createJobDetailView() -> JobDetailViewController
}

protocol JobPostViewModelFactory: ViewModelFactory {
    func createJobPostViewModel() -> JobPostViewModel
    func createJobListViewModel() -> JobListViewModel
    func createJobDetailViewModel() -> JobDetailViewModel
}

protocol JobPostCoordinatorFactory: CoordinatorFactory {
    func createJobPostCoordinator(navigationController: UINavigationController) -> JobPostCoordinator
}

// Worker Profile Module
protocol WorkerProfileViewFactory: ViewFactory {
    func createProfileView() -> WorkerProfileViewController
    func createEditProfileView() -> WorkerEditProfileViewController
    func createSkillsView() -> WorkerSkillsViewController
}

protocol WorkerProfileViewModelFactory: ViewModelFactory {
    func createProfileViewModel() -> WorkerProfileViewModel
    func createEditProfileViewModel() -> WorkerEditProfileViewModel
    func createSkillsViewModel() -> WorkerSkillsViewModel
}

protocol WorkerProfileCoordinatorFactory: CoordinatorFactory {
    func createWorkerProfileCoordinator(navigationController: UINavigationController) -> WorkerProfileCoordinator
}

// Job Search Module
protocol JobSearchViewFactory: ViewFactory {
    func createSearchView() -> JobSearchViewController
    func createFilterView() -> JobSearchFilterViewController
    func createResultsView() -> JobSearchResultsViewController
}

protocol JobSearchViewModelFactory: ViewModelFactory {
    func createSearchViewModel() -> JobSearchViewModel
    func createFilterViewModel() -> JobSearchFilterViewModel
    func createResultsViewModel() -> JobSearchResultsViewModel
}

protocol JobSearchCoordinatorFactory: CoordinatorFactory {
    func createJobSearchCoordinator(navigationController: UINavigationController) -> JobSearchCoordinator
}

// Booking Module
protocol BookingViewFactory: ViewFactory {
    func createBookingView() -> BookingViewController
    func createBookingHistoryView() -> BookingHistoryViewController
    func createBookingDetailView() -> BookingDetailViewController
}

protocol BookingViewModelFactory: ViewModelFactory {
    func createBookingViewModel() -> BookingViewModel
    func createBookingHistoryViewModel() -> BookingHistoryViewModel
    func createBookingDetailViewModel() -> BookingDetailViewModel
}

protocol BookingCoordinatorFactory: CoordinatorFactory {
    func createBookingCoordinator(navigationController: UINavigationController) -> BookingCoordinator
}

// Payments Module
protocol PaymentsViewFactory: ViewFactory {
    func createPaymentsView() -> PaymentsViewController
    func createPaymentMethodsView() -> PaymentMethodsViewController
    func createTransactionHistoryView() -> TransactionHistoryViewController
}

protocol PaymentsViewModelFactory: ViewModelFactory {
    func createPaymentsViewModel() -> PaymentsViewModel
    func createPaymentMethodsViewModel() -> PaymentMethodsViewModel
    func createTransactionHistoryViewModel() -> TransactionHistoryViewModel
}

protocol PaymentsCoordinatorFactory: CoordinatorFactory {
    func createPaymentsCoordinator(navigationController: UINavigationController) -> PaymentsCoordinator
}

// Reviews Module
protocol ReviewsViewFactory: ViewFactory {
    func createReviewsView() -> ReviewsViewController
    func createWriteReviewView() -> WriteReviewViewController
    func createReviewDetailView() -> ReviewDetailViewController
}

protocol ReviewsViewModelFactory: ViewModelFactory {
    func createReviewsViewModel() -> ReviewsViewModel
    func createWriteReviewViewModel() -> WriteReviewViewModel
    func createReviewDetailViewModel() -> ReviewDetailViewModel
}

protocol ReviewsCoordinatorFactory: CoordinatorFactory {
    func createReviewsCoordinator(navigationController: UINavigationController) -> ReviewsCoordinator
}

// Settings Module
protocol SettingsViewFactory: ViewFactory {
    func createSettingsView() -> SettingsViewController
    func createAccountSettingsView() -> AccountSettingsViewController
    func createNotificationSettingsView() -> NotificationSettingsViewController
}

protocol SettingsViewModelFactory: ViewModelFactory {
    func createSettingsViewModel() -> SettingsViewModel
    func createAccountSettingsViewModel() -> AccountSettingsViewModel
    func createNotificationSettingsViewModel() -> NotificationSettingsViewModel
}

protocol SettingsCoordinatorFactory: CoordinatorFactory {
    func createSettingsCoordinator(navigationController: UINavigationController) -> SettingsCoordinator
}

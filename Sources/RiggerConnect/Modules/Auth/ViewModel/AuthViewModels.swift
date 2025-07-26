//
//  AuthViewModels.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import Combine
import UIKit

// MARK: - Base Auth ViewModel

class BaseAuthViewModel: ObservableObject, ViewModelDependency {
    
    // MARK: - Dependencies
    var container: DependencyContainer
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFormValid = false
    
    // MARK: - Services
    internal lazy var authService: AuthServiceProtocol = {
        // For now, return a mock service since AuthServiceProtocol implementation doesn't exist yet
        return MockAuthService()
    }()
    
    // MARK: - Initialization
    init(container: DependencyContainer) {
        self.container = container
    }
    
    // MARK: - Common Methods
    func clearError() {
        errorMessage = nil
    }
    
    func handleError(_ error: Error) {
        isLoading = false
        if let authError = error as? AuthError {
            errorMessage = authError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred. Please try again."
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Auth Login ViewModel

class AuthLoginViewModel: BaseAuthViewModel {
    
    // MARK: - Published Properties
    @Published var email = ""
    @Published var password = ""
    @Published var rememberMe = false
    @Published var showPassword = false
    
    // MARK: - Validation
    private var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValid: AnyPublisher<Bool, Never> {
        $password
            .map { $0.count >= 6 }
            .eraseToAnyPublisher()
    }
    
    override init(container: DependencyContainer) {
        super.init(container: container)
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest(isEmailValid, isPasswordValid)
            .map { $0 && $1 }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func login() {
        guard isFormValid else { return }
        
        isLoading = true
        clearError()
        
        let request = AuthLoginRequest(
            email: email.trimmingCharacters(in: .whitespaces),
            password: password,
            rememberMe: rememberMe
        )
        
        authService.login(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] tokenResponse in
                    // Success handled by AuthService state management
                    self?.clearForm()
                }
            )
            .store(in: &cancellables)
    }
    
    func forgotPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address first."
            return
        }
        
        isLoading = true
        clearError()
        
        let request = AuthForgotPasswordRequest(email: email.trimmingCharacters(in: .whitespaces))
        
        authService.forgotPassword(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] _ in
                    // Show success message
                    self?.errorMessage = "Password reset instructions sent to your email."
                }
            )
            .store(in: &cancellables)
    }
    
    private func clearForm() {
        email = ""
        password = ""
        rememberMe = false
        showPassword = false
    }
}

// MARK: - Auth SignUp ViewModel

class AuthSignUpViewModel: BaseAuthViewModel {
    
    // MARK: - Published Properties
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var userType: UserType = .rigger
    @Published var acceptedTerms = false
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    
    // MARK: - Validation
    private var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValid: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                // Password must be at least 8 characters with uppercase, lowercase, and numbers
                let hasMinLength = password.count >= 8
                let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
                let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
                let hasNumbers = password.range(of: "[0-9]", options: .regularExpression) != nil
                return hasMinLength && hasUppercase && hasLowercase && hasNumbers
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordsMatch: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .map { password, confirmPassword in
                !password.isEmpty && password == confirmPassword
            }
            .eraseToAnyPublisher()
    }
    
    private var isNameValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($firstName, $lastName)
            .map { firstName, lastName in
                !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
                !lastName.trimmingCharacters(in: .whitespaces).isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    override init(container: DependencyContainer) {
        super.init(container: container)
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest4(isEmailValid, isPasswordValid, passwordsMatch, isNameValid)
            .combineLatest($acceptedTerms)
            .map { validation, acceptedTerms in
                validation.0 && validation.1 && validation.2 && validation.3 && acceptedTerms
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func signUp() {
        guard isFormValid else { return }
        
        isLoading = true
        clearError()
        
        let request = AuthSignUpRequest(
            email: email.trimmingCharacters(in: .whitespaces),
            password: password,
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            userType: userType,
            acceptedTerms: acceptedTerms
        )
        
        authService.signUp(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] tokenResponse in
                    // Success handled by AuthService state management
                    self?.clearForm()
                }
            )
            .store(in: &cancellables)
    }
    
    private func clearForm() {
        email = ""
        password = ""
        confirmPassword = ""
        firstName = ""
        lastName = ""
        userType = .rigger
        acceptedTerms = false
        showPassword = false
        showConfirmPassword = false
    }
}

// MARK: - Auth Forgot Password ViewModel

class AuthForgotPasswordViewModel: BaseAuthViewModel {
    
    // MARK: - Published Properties
    @Published var email = ""
    @Published var emailSent = false
    
    // MARK: - Validation
    private var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    override init(container: DependencyContainer) {
        super.init(container: container)
        setupValidation()
    }
    
    private func setupValidation() {
        isEmailValid
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func sendResetEmail() {
        guard isFormValid else { return }
        
        isLoading = true
        clearError()
        
        let request = AuthForgotPasswordRequest(email: email.trimmingCharacters(in: .whitespaces))
        
        authService.forgotPassword(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.emailSent = true
                }
            )
            .store(in: &cancellables)
    }
    
    func resendEmail() {
        emailSent = false
        sendResetEmail()
    }
}

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol {
    func login(request: AuthLoginRequest) -> AnyPublisher<AuthTokenResponse, Error>
    func signUp(request: AuthSignUpRequest) -> AnyPublisher<AuthTokenResponse, Error>
    func forgotPassword(request: AuthForgotPasswordRequest) -> AnyPublisher<Void, Error>
    func resetPassword(request: AuthResetPasswordRequest) -> AnyPublisher<Void, Error>
    func logout() -> AnyPublisher<Void, Error>
    func refreshToken() -> AnyPublisher<AuthTokenResponse, Error>
    var currentUser: AuthUser? { get }
    var authState: CurrentValueSubject<AuthState, Never> { get }
}

// MARK: - Mock Auth Service (for development)

class MockAuthService: AuthServiceProtocol {
    var currentUser: AuthUser?
    var authState = CurrentValueSubject<AuthState, Never>(.unauthenticated)
    
    func login(request: AuthLoginRequest) -> AnyPublisher<AuthTokenResponse, Error> {
        // Simulate network delay
        return Just(mockTokenResponse())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func signUp(request: AuthSignUpRequest) -> AnyPublisher<AuthTokenResponse, Error> {
        return Just(mockTokenResponse())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func forgotPassword(request: AuthForgotPasswordRequest) -> AnyPublisher<Void, Error> {
        return Just(())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func resetPassword(request: AuthResetPasswordRequest) -> AnyPublisher<Void, Error> {
        return Just(())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return Just(())
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.currentUser = nil
                self?.authState.send(.unauthenticated)
            })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<AuthTokenResponse, Error> {
        return Just(mockTokenResponse())
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func mockTokenResponse() -> AuthTokenResponse {
        let mockUser = AuthUser(
            id: UUID(),
            email: "demo@riggerconnect.com",
            firstName: "Demo",
            lastName: "User",
            userType: .business,
            isEmailVerified: true,
            profileImageURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        return AuthTokenResponse(
            accessToken: "mock-access-token",
            refreshToken: "mock-refresh-token",
            expiresIn: 3600,
            tokenType: "Bearer",
            user: mockUser
        )
    }
}

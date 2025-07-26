//
//  AuthViewModelTests.swift
//  RiggerConnect iOS Tests
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import XCTest
import Combine
@testable import RiggerConnect

class AuthViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var mockContainer: MockDependencyContainer!
    var mockAuthService: MockAuthService!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockContainer = MockDependencyContainer()
        mockAuthService = MockAuthService()
        cancellables = Set<AnyCancellable>()
        
        mockContainer.register(AuthServiceProtocol.self) { [weak self] in
            return self?.mockAuthService ?? MockAuthService()
        }
    }
    
    override func tearDown() {
        cancellables.removeAll()
        mockAuthService = nil
        mockContainer = nil
        super.tearDown()
    }
    
    // MARK: - Auth Login ViewModel Tests
    
    func testAuthLoginViewModel_InitialState() {
        // Given
        let viewModel = AuthLoginViewModel(container: mockContainer)
        
        // Then
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.rememberMe)
        XCTAssertFalse(viewModel.showPassword)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testAuthLoginViewModel_EmailValidation() {
        // Given
        let viewModel = AuthLoginViewModel(container: mockContainer)
        let expectation = XCTestExpectation(description: "Form validation")
        
        viewModel.$isFormValid
            .dropFirst() // Skip initial value
            .sink { isValid in
                if !isValid {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.email = "invalid-email"
        viewModel.password = "validpassword"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func testAuthLoginViewModel_ValidCredentials() {
        // Given
        let viewModel = AuthLoginViewModel(container: mockContainer)
        let expectation = XCTestExpectation(description: "Form validation")
        
        viewModel.$isFormValid
            .dropFirst() // Skip initial value
            .sink { isValid in
                if isValid {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func testAuthLoginViewModel_LoginSuccess() {
        // Given
        let viewModel = AuthLoginViewModel(container: mockContainer)
        let mockUser = AuthUser(
            id: UUID(),
            email: "test@example.com",
            firstName: "Test",
            lastName: "User",
            userType: .rigger,
            isEmailVerified: true,
            profileImageURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        let mockResponse = AuthTokenResponse(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            expiresIn: 3600,
            tokenType: "Bearer",
            user: mockUser
        )
        
        mockAuthService.loginResult = .success(mockResponse)
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        let expectation = XCTestExpectation(description: "Login success")
        
        viewModel.$isLoading
            .sink { isLoading in
                if !isLoading && viewModel.email.isEmpty {
                    // Form was cleared after successful login
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.login()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testAuthLoginViewModel_LoginFailure() {
        // Given
        let viewModel = AuthLoginViewModel(container: mockContainer)
        mockAuthService.loginResult = .failure(AuthError.invalidCredentials)
        
        viewModel.email = "test@example.com"
        viewModel.password = "wrong-password"
        
        let expectation = XCTestExpectation(description: "Login failure")
        
        viewModel.$errorMessage
            .sink { errorMessage in
                if let error = errorMessage, !error.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.login()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Auth SignUp ViewModel Tests
    
    func testAuthSignUpViewModel_InitialState() {
        // Given
        let viewModel = AuthSignUpViewModel(container: mockContainer)
        
        // Then
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.confirmPassword, "")
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        XCTAssertEqual(viewModel.userType, .rigger)
        XCTAssertFalse(viewModel.acceptedTerms)
        XCTAssertFalse(viewModel.showPassword)
        XCTAssertFalse(viewModel.showConfirmPassword)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testAuthSignUpViewModel_PasswordValidation() {
        // Given
        let viewModel = AuthSignUpViewModel(container: mockContainer)
        
        // Set all fields except password to valid values
        viewModel.email = "test@example.com"
        viewModel.firstName = "Test"
        viewModel.lastName = "User"
        viewModel.acceptedTerms = true
        
        let expectation = XCTestExpectation(description: "Password validation")
        
        viewModel.$isFormValid
            .sink { isValid in
                if !isValid && !viewModel.password.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - weak password
        viewModel.password = "weak"
        viewModel.confirmPassword = "weak"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func testAuthSignUpViewModel_StrongPasswordValidation() {
        // Given
        let viewModel = AuthSignUpViewModel(container: mockContainer)
        
        let expectation = XCTestExpectation(description: "Strong password validation")
        
        viewModel.$isFormValid
            .sink { isValid in
                if isValid {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - all valid fields
        viewModel.email = "test@example.com"
        viewModel.password = "StrongPass123"
        viewModel.confirmPassword = "StrongPass123"
        viewModel.firstName = "Test"
        viewModel.lastName = "User"
        viewModel.acceptedTerms = true
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func testAuthSignUpViewModel_PasswordMismatch() {
        // Given
        let viewModel = AuthSignUpViewModel(container: mockContainer)
        
        // Set all fields to valid values
        viewModel.email = "test@example.com"
        viewModel.firstName = "Test"
        viewModel.lastName = "User"
        viewModel.acceptedTerms = true
        
        let expectation = XCTestExpectation(description: "Password mismatch validation")
        
        viewModel.$isFormValid
            .sink { isValid in
                if !isValid && !viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - passwords don't match
        viewModel.password = "StrongPass123"
        viewModel.confirmPassword = "DifferentPass123"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    // MARK: - Auth Forgot Password ViewModel Tests
    
    func testAuthForgotPasswordViewModel_InitialState() {
        // Given
        let viewModel = AuthForgotPasswordViewModel(container: mockContainer)
        
        // Then
        XCTAssertEqual(viewModel.email, "")
        XCTAssertFalse(viewModel.emailSent)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testAuthForgotPasswordViewModel_EmailValidation() {
        // Given
        let viewModel = AuthForgotPasswordViewModel(container: mockContainer)
        
        let expectation = XCTestExpectation(description: "Email validation")
        
        viewModel.$isFormValid
            .sink { isValid in
                if isValid {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.email = "test@example.com"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func testAuthForgotPasswordViewModel_SendResetEmailSuccess() {
        // Given
        let viewModel = AuthForgotPasswordViewModel(container: mockContainer)
        mockAuthService.forgotPasswordResult = .success(())
        
        viewModel.email = "test@example.com"
        
        let expectation = XCTestExpectation(description: "Reset email sent")
        
        viewModel.$emailSent
            .sink { emailSent in
                if emailSent {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.sendResetEmail()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.emailSent)
        XCTAssertFalse(viewModel.isLoading)
    }
}

// MARK: - Mock Classes

class MockDependencyContainer: DependencyContainer {
    private var registrations: [String: () -> Any] = [:]
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        registrations[key] = factory
    }
    
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        register(type, factory: factory)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let factory = registrations[key] else {
            fatalError("Type \(type) not registered")
        }
        return factory() as! T
    }
    
    func resolveOptional<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return registrations[key]?() as? T
    }
    
    func isRegistered<T>(_ type: T.Type) -> Bool {
        let key = String(describing: type)
        return registrations[key] != nil
    }
    
    func clear() {
        registrations.removeAll()
    }
}

class MockAuthService: AuthServiceProtocol {
    var loginResult: Result<AuthTokenResponse, Error> = .failure(AuthError.networkError("Mock error"))
    var signUpResult: Result<AuthTokenResponse, Error> = .failure(AuthError.networkError("Mock error"))
    var forgotPasswordResult: Result<Void, Error> = .failure(AuthError.networkError("Mock error"))
    var resetPasswordResult: Result<Void, Error> = .failure(AuthError.networkError("Mock error"))
    var logoutResult: Result<Void, Error> = .success(())
    var refreshTokenResult: Result<AuthTokenResponse, Error> = .failure(AuthError.networkError("Mock error"))
    
    var currentUser: AuthUser?
    var authState = CurrentValueSubject<AuthState, Never>(.idle)
    
    func login(request: AuthLoginRequest) -> AnyPublisher<AuthTokenResponse, Error> {
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.loginResult)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(request: AuthSignUpRequest) -> AnyPublisher<AuthTokenResponse, Error> {
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.signUpResult)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func forgotPassword(request: AuthForgotPasswordRequest) -> AnyPublisher<Void, Error> {
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.forgotPasswordResult)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func resetPassword(request: AuthResetPasswordRequest) -> AnyPublisher<Void, Error> {
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.resetPasswordResult)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.logoutResult)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<AuthTokenResponse, Error> {
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.refreshTokenResult)
            }
        }
        .eraseToAnyPublisher()
    }
}

//
//  AuthCoordinator.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import UIKit
import Combine

// MARK: - Auth Coordinator Protocol

protocol AuthCoordinatorProtocol: AnyObject {
    func start()
    func showLogin()
    func showSignUp()
    func showForgotPassword()
    func showMainApp()
    func dismiss()
}

// MARK: - Auth Coordinator

class AuthCoordinator: NSObject, AuthCoordinatorProtocol, CoordinatorDependency {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var container: DependencyContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Child Coordinators
    private var childCoordinators: [AnyObject] = []
    
    // MARK: - Services
    private lazy var authService: AuthServiceProtocol = {
        return MockAuthService()
    }()
    
    // MARK: - Completion Handler
    var onAuthenticationComplete: (() -> Void)?
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
        super.init()
        
        observeAuthState()
    }
    
    // MARK: - Coordinator Protocol
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let loginViewController = AuthLoginViewController()
        let loginViewModel = AuthLoginViewModel(container: container)
        
        loginViewController.viewModel = loginViewModel
        loginViewController.coordinator = self
        
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    
    func showSignUp() {
        let signUpViewController = AuthSignUpViewController()
        let signUpViewModel = AuthSignUpViewModel(container: container)
        
        signUpViewController.viewModel = signUpViewModel
        signUpViewController.coordinator = self
        
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func showForgotPassword() {
        let forgotPasswordViewController = AuthForgotPasswordViewController()
        let forgotPasswordViewModel = AuthForgotPasswordViewModel(container: container)
        
        forgotPasswordViewController.viewModel = forgotPasswordViewModel
        forgotPasswordViewController.coordinator = self
        
        navigationController.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    func showMainApp() {
        onAuthenticationComplete?()
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    private func observeAuthState() {
        authService.authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .authenticated:
                    self?.showMainApp()
                case .unauthenticated, .error:
                    // Stay on current auth screen
                    break
                case .idle, .loading:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
        childCoordinators.removeAll()
    }
}

// MARK: - Auth View Controller Base

class BaseAuthViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: AuthCoordinatorProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup Methods (Override in subclasses)
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add common UI elements
        setupNavigationBar()
    }
    
    func setupBindings() {
        // Override in subclasses for specific bindings
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
    }
    
    // MARK: - Helper Methods
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }
}

// MARK: - Auth Login View Controller

class AuthLoginViewController: BaseAuthViewController {
    
    // MARK: - Properties
    var viewModel: AuthLoginViewModel!
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "rigger_logo")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome Back"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign in to continue"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show", for: .normal)
        button.setTitle("Hide", for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var rememberMeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remember Me", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func setupUI() {
        super.setupUI()
        
        title = "Sign In"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [logoImageView, titleLabel, subtitleLabel, emailTextField, passwordTextField,
         showPasswordButton, rememberMeButton, loginButton, forgotPasswordButton,
         signUpButton, loadingIndicator].forEach { contentView.addSubview($0) }
        
        setupConstraints()
        setupActions()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        // Bind text fields to view model
        emailTextField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        
        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                    self?.loginButton.setTitle("", for: .normal)
                    self?.loginButton.isEnabled = false
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.loginButton.setTitle("Sign In", for: .normal)
                    self?.loginButton.isEnabled = true
                }
            }
            .store(in: &viewModel.cancellables)
        
        // Bind form validation
        viewModel.$isFormValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.loginButton.alpha = isValid ? 1.0 : 0.6
            }
            .store(in: &viewModel.cancellables)
        
        // Bind error messages
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage, !message.isEmpty {
                    self?.showErrorAlert(message: message)
                }
            }
            .store(in: &viewModel.cancellables)
        
        // Bind show password
        viewModel.$showPassword
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showPassword in
                self?.passwordTextField.isSecureTextEntry = !showPassword
                self?.showPasswordButton.isSelected = showPassword
            }
            .store(in: &viewModel.cancellables)
        
        // Bind remember me
        viewModel.$rememberMe
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rememberMe in
                self?.rememberMeButton.isSelected = rememberMe
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Actions
    @objc private func emailTextChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    @objc private func passwordTextChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    private func setupActions() {
        showPasswordButton.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
        rememberMeButton.addTarget(self, action: #selector(rememberMeTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc private func showPasswordTapped() {
        viewModel.showPassword.toggle()
    }
    
    @objc private func rememberMeTapped() {
        viewModel.rememberMe.toggle()
    }
    
    @objc private func loginTapped() {
        viewModel.login()
    }
    
    @objc private func forgotPasswordTapped() {
        coordinator?.showForgotPassword()
    }
    
    @objc private func signUpTapped() {
        coordinator?.showSignUp()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor, constant: -8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Show Password Button
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 50),
            
            // Remember Me Button
            rememberMeButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            rememberMeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: rememberMeButton.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            // Forgot Password Button
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 32),
            signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}

// MARK: - Placeholder View Controllers

class AuthSignUpViewController: BaseAuthViewController {
    var viewModel: AuthSignUpViewModel!
    
    override func setupUI() {
        super.setupUI()
        title = "Sign Up"
        
        // TODO: Implement full UI
        let label = UILabel()
        label.text = "Sign Up Screen"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class AuthForgotPasswordViewController: BaseAuthViewController {
    var viewModel: AuthForgotPasswordViewModel!
    
    override func setupUI() {
        super.setupUI()
        title = "Forgot Password"
        
        // TODO: Implement full UI
        let label = UILabel()
        label.text = "Forgot Password Screen"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

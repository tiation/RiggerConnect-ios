//
//  DependencyConfigurator.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import UIKit

class DependencyConfigurator {
    
    static func configure(container: DependencyContainer) {
        configureServices(container: container)
        configureViewModels(container: container)
        configureViewControllers(container: container)
        configureCoordinators(container: container)
        configureFactories(container: container)
    }
    
    // MARK: - Services
    private static func configureServices(container: DependencyContainer) {
        // Auth Service
        container.registerSingleton(AuthServiceProtocol.self) {
            AuthService()
        }
    }
    
    // MARK: - ViewModels
    private static func configureViewModels(container: DependencyContainer) {
        // Auth ViewModels
        container.register(AuthLoginViewModel.self) {
            AuthLoginViewModel(container: container)
        }
        
        container.register(AuthSignUpViewModel.self) {
            AuthSignUpViewModel(container: container)
        }
        
        container.register(AuthForgotPasswordViewModel.self) {
            AuthForgotPasswordViewModel(container: container)
        }
    }
    
    // MARK: - View Controllers
    private static func configureViewControllers(container: DependencyContainer) {
        // Auth View Controllers
        container.register(AuthLoginViewController.self) {
            AuthLoginViewController()
        }
        
        container.register(AuthSignUpViewController.self) {
            AuthSignUpViewController()
        }
        
        container.register(AuthForgotPasswordViewController.self) {
            AuthForgotPasswordViewController()
        }
    }
    
    // MARK: - Coordinators
    private static func configureCoordinators(container: DependencyContainer) {
        // Note: Coordinators are created with navigation controller parameters,
        // so they can't be pre-registered in the container
    }
    
    // MARK: - Factories
    private static func configureFactories(container: DependencyContainer) {
        // Auth Factories
        container.registerSingleton(AuthViewFactory.self) {
            ConcreteAuthViewFactory(container: container)
        }
        
        container.registerSingleton(AuthViewModelFactory.self) {
            ConcreteAuthViewModelFactory(container: container)
        }
        
        container.registerSingleton(AuthCoordinatorFactory.self) {
            ConcreteAuthCoordinatorFactory(container: container)
        }
    }
}

// MARK: - Concrete Factory Implementations

class ConcreteAuthViewFactory: AuthViewFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func createView() -> AuthLoginViewController {
        return createLoginView()
    }
    
    func createLoginView() -> AuthLoginViewController {
        return container.resolve(AuthLoginViewController.self)
    }
    
    func createSignUpView() -> AuthSignUpViewController {
        return container.resolve(AuthSignUpViewController.self)
    }
    
    func createForgotPasswordView() -> AuthForgotPasswordViewController {
        return container.resolve(AuthForgotPasswordViewController.self)
    }
}

class ConcreteAuthViewModelFactory: AuthViewModelFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func createViewModel() -> AuthLoginViewModel {
        return createLoginViewModel()
    }
    
    func createLoginViewModel() -> AuthLoginViewModel {
        return container.resolve(AuthLoginViewModel.self)
    }
    
    func createSignUpViewModel() -> AuthSignUpViewModel {
        return container.resolve(AuthSignUpViewModel.self)
    }
    
    func createForgotPasswordViewModel() -> AuthForgotPasswordViewModel {
        return container.resolve(AuthForgotPasswordViewModel.self)
    }
}

class ConcreteAuthCoordinatorFactory: AuthCoordinatorFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func createCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        return createAuthCoordinator(navigationController: navigationController)
    }
    
    func createAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        return AuthCoordinator(navigationController: navigationController, container: container)
    }
}

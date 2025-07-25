//
//  DependencyContainer.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import Combine

/// Core dependency injection container protocol
protocol DependencyContainer {
    /// Register a dependency with a unique key
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    
    /// Register a singleton dependency
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T)
    
    /// Resolve a dependency by type
    func resolve<T>(_ type: T.Type) -> T
    
    /// Resolve an optional dependency
    func resolveOptional<T>(_ type: T.Type) -> T?
    
    /// Check if a dependency is registered
    func isRegistered<T>(_ type: T.Type) -> Bool
    
    /// Clear all registrations
    func clear()
}

/// Factory protocol for creating dependencies
protocol DependencyFactory {
    associatedtype ProductType
    func create() -> ProductType
}

/// Coordinator dependency protocol
protocol CoordinatorDependency {
    var navigationController: UINavigationController { get }
    var container: DependencyContainer { get }
}

/// Service dependency protocol
protocol ServiceDependency {
    var container: DependencyContainer { get }
}

/// ViewModel dependency protocol
protocol ViewModelDependency {
    var container: DependencyContainer { get }
    var cancellables: Set<AnyCancellable> { get set }
}

//
//  DependencyResolver.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO
//  Built by Jack Jonas (WA rigger) & Tia (dev, ChaseWhiteRabbit NGO)
//  Email: jackjonas95@gmail.com, tiatheone@protonmail.com
//

import Foundation
import Combine
import UIKit

/// Thread-safe dependency injection container implementation
final class DependencyResolver: DependencyContainer {
    
    // MARK: - Singleton
    static let shared = DependencyResolver()
    
    // MARK: - Private Properties
    private var factories: [String: () -> Any] = [:]
    private var singletons: [String: Any] = [:]
    private let queue = DispatchQueue(label: "dependency.resolver.queue", attributes: .concurrent)
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - DependencyContainer Implementation
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.factories[key] = factory
        }
    }
    
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.factories[key] = factory
            // Don't create singleton until first access
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        return queue.sync {
            let key = String(describing: type)
            
            // Check if singleton exists
            if let singleton = singletons[key] as? T {
                return singleton
            }
            
            // Get factory and create instance
            guard let factory = factories[key] else {
                fatalError("Dependency \(type) not registered. Make sure to register it in DependencyConfigurator.")
            }
            
            let instance = factory() as! T
            
            // Store as singleton if this was registered as singleton
            if singletons[key] == nil && factories[key] != nil {
                singletons[key] = instance
            }
            
            return instance
        }
    }
    
    func resolveOptional<T>(_ type: T.Type) -> T? {
        return queue.sync {
            let key = String(describing: type)
            
            // Check if singleton exists
            if let singleton = singletons[key] as? T {
                return singleton
            }
            
            // Get factory and create instance
            guard let factory = factories[key] else {
                return nil
            }
            
            let instance = factory() as! T
            
            // Store as singleton if this was registered as singleton
            if singletons[key] == nil {
                singletons[key] = instance
            }
            
            return instance
        }
    }
    
    func isRegistered<T>(_ type: T.Type) -> Bool {
        return queue.sync {
            let key = String(describing: type)
            return factories[key] != nil
        }
    }
    
    func clear() {
        queue.async(flags: .barrier) {
            self.factories.removeAll()
            self.singletons.removeAll()
        }
    }
}

// MARK: - Convenience Extensions

extension DependencyResolver {
    
    /// Register a singleton with immediate creation
    func registerEagerSingleton<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.singletons[key] = instance
            self.factories[key] = { instance }
        }
    }
    
    /// Register multiple dependencies at once
    func registerBatch(_ registrations: () -> Void) {
        queue.async(flags: .barrier) {
            registrations()
        }
    }
}

//
//  CoreDataManager+Seed.swift
//  Notes
//
//  Created by Bart Jacobs on 12/02/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import CoreData

extension CoreDataManager {
    
    // MARK: - Public API
    
    func seed(_ completion: (() -> Void)? = nil) {
        guard !UserDefaults.didSeedPersistentStore else {
            return
        }
        
        // Initialize Operation
        let operation = SeedOperation(with: mainManagedObjectContext) { (success) in
            completion?()
            
            // Update User Defaults
            UserDefaults.setDidSeedPersistentStore(success)
        }
        
        // Add to Operation Queue
        operationQueue.addOperation(operation)
    }

}

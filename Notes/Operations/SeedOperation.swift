//
//  SeedOperation.swift
//  Notes
//
//  Created by Bart Jacobs on 14/02/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import CoreData
import Foundation

class SeedOperation: Operation {

    // MARK: - Error Handling
    
    enum SeedError: Error {
        
        case seedDataNotFound
        
    }
    
    // MARK: - Type Alias
    
    typealias SeedOperationCompletion = ((Bool) -> Void)
    
    // MARK: - Properties
    
    let privateManagedObjectContext: NSManagedObjectContext
    
    // MARK: -
    
    let completion: SeedOperationCompletion?
    
    // MARK: - Initialization

    init(with managedObjectContext: NSManagedObjectContext, completion: SeedOperationCompletion? = nil) {
        // Initialize Managed Object Context
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        privateManagedObjectContext.parent = managedObjectContext
        
        // Set Completion
        self.completion = completion
        
        super.init()
    }
    
    // MARK: - Overrides
    
    override func main() {
        do {
            // Seed With Data
            try seed()
            
            // Invoke Completion
            completion?(true)
        } catch {
            print("Unable to Save Managed Object Context After Seeding Persistent Store (\(error))")
            
            // Invoke Completion
            completion?(false)
        }
    }
    
    // MARK: - Helper Methods
    
    private func seed() throws {
        // Load Seed Data From Bundle
        guard let url = Bundle.main.url(forResource: "seed", withExtension: "json") else {
            throw SeedError.seedDataNotFound
        }
        
        // Load Data
        let data = try Data(contentsOf: url)
        
        // Initialize JSON Decoder
        let decoder = JSONDecoder()
        
        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // Decode Seed Data
        let seed = try decoder.decode(Seed.self, from: data)
        
        // Helpers
        var tagsBuffer: [Tag] = []
        var categoriesBuffer: [Category] = []
        
        for data in seed.tags {
            // Initialize Tag
            let tag = Tag(context: privateManagedObjectContext)
            
            // Configure Tag
            tag.name = data.name
            
            // Append to Buffer
            tagsBuffer.append(tag)
        }
        
        for data in seed.categories {
            // Initialize Category
            let category = Category(context: privateManagedObjectContext)
            
            // Configure Category
            category.name = data.name
            category.colorAsHex = data.colorAsHex
            
            // Append to Buffer
            categoriesBuffer.append(category)
        }
        
        for data in seed.notes {
            // Initialize Note
            let note = Note(context: privateManagedObjectContext)
            
            // Configure Note
            note.title = data.title
            note.contents = data.contents
            note.createdAt = data.createdAt
            note.updatedAt = data.updatedAt
            
            // Add Category
            note.category = categoriesBuffer.first {
                return $0.name == data.category
            }
            
            // Helpers
            let tagsAsSet = Set(data.tags)
            
            // Add Tags
            for tag in tagsBuffer {
                guard let name = tag.name else {
                    continue
                }
                
                if tagsAsSet.contains(name) {
                    note.addToTags(tag)
                }
            }
        }

        // Save Changes
        try privateManagedObjectContext.save()
    }

}

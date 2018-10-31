//
//  NoteData.swift
//  Notes
//
//  Created by Bart Jacobs on 18/02/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import Foundation

struct NoteData: Codable {
    
    // MARK: - Properties
    
    let title: String
    let contents: String
    
    let createdAt: Date
    let updatedAt: Date
    
    // MARK: - Relationships
    
    let tags: [String]
    let category : String
    
}

//
//  Seed.swift
//  Notes
//
//  Created by Bart Jacobs on 14/02/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import Foundation

struct Seed: Codable {

    // MARK: - Properties
    
    let tags: [TagData]
    let categories: [CategoryData]
    let notes: [NoteData]
    
}

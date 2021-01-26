//
//  Item.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import Foundation


final class Item: Codable {
    let id: UUID?
    let name: String
    let description: String
    let location: String
    
    init(id: UUID? = nil, name: String, location: String, description: String) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
    }
}

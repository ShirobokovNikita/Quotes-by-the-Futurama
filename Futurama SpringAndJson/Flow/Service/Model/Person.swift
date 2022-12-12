//
//  Person.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 04.12.22.
//

import UIKit

struct Person: Codable {
    let name: Name
    let images: Images
    let sayings: [String]
}


// MARK: - Images
struct Images: Codable {
    let headShot: String
    let main: String

    enum CodingKeys: String, CodingKey {
        case headShot = "head-shot"
        case main
    }
}

// MARK: - Name
struct Name: Codable {
    let first, middle, last: String
}


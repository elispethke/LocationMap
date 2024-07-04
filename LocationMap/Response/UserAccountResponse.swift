//
//  UserAccountResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct UserAccountResponse: Codable {
    
    let lastName: String?
    let firstName: String?
    let userId: String?

    enum CodingKeys: String, CodingKey {
        case lastName = "user_last_name"
        case firstName = "user_first_name"
        case userId = "user_id"
    }

 
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(userId, forKey: .userId)
    }
}

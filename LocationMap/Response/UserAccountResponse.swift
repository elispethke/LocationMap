//
//  UserAccountResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct UserAccountResponse: Codable {
    
    let familyName: String?
    let givenName: String?
    let userId: String?

    enum CodingKeys: String, CodingKey {
        case familyName = "user_last_name"
        case givenName = "user_first_name"
        case userId = "user_id"
    }

 
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(familyName, forKey: .familyName)
        try container.encode(givenName, forKey: .givenName)
        try container.encode(userId, forKey: .userId)
    }
}

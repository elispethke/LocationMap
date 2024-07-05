//
//  SignInResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct SignInResponse: Codable {
    let profile: Profile
    let connection: Connection
    
    enum CodingKeys: String, CodingKey {
        case profile
        case connection
    }
    
    struct Profile: Codable {
        let enrolled: Bool
        let identifier: String
        
        enum CodingKeys: String, CodingKey {
            case enrolled
            case identifier = "identifier"
        }
    }
    
    struct Connection: Codable {
        let id: String
        let expiry: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case expiry
        }
    }
}

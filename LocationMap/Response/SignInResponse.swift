//
//  SignInResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct SignInResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
    
    struct Account: Codable {
        let registered: Bool
        let key: String
        
        enum CodingKeys: String, CodingKey {
            case registered
            case key = "key"
        }
    }
    
    struct Session: Codable {
        let id: String
        let expiration: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case expiration
        }
    }
}

//
//  LearnerLocationsResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 05.07.24.
//

import Foundation

struct LearnerLocationsResponse: Codable {
    let results: [LearnerLocation]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct LearnerLocation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let giventName: String?
    let familyName: String?
    let locationString : String?
    let urlMedia: String?
    let lat: Double
    let long: Double
    let createdDateString: String?
    let updatedDateString: String?
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case uniqueKey
        case giventName
        case familyName
        case locationString
        case urlMedia
        case lat
        case long
        case createdDateString
        case updatedDateString
    }
}

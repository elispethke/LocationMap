//
//  PlaceStudentRequest.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct PlaceStudentRequest: Codable{
    let uniqueIdentifier: String
    let givenName: String
    let familyName: String
    let locationString: String
    let urlMedia: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case uniqueIdentifier = "uniqueKey"
        case givenName = "giventName"
        case familyName = "familyName"
        case locationString = "locationString"
        case urlMedia = "urlMedia"
        case lat = "latitude"
        case lon = "longitude"
    }
}

struct UserPostLocationResponse: Codable {
    let customIdentifier: String
    let createdDateString: String
    
    enum CodingKeys: String, CodingKey {
        case customIdentifier = "customIdentifier"
        case createdDateString = "createdDateString"
    }
}

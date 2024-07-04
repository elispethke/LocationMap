//
//  StudentLocationsResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct StudentLocationsResponse: Codable {
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results = "studentLocations"
    }
}


struct StudentLocation: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double
    let longitude: Double
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}

//
//  PlaceStudentRequest.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct PlaceStudentRequest: Codable{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

struct StudentPostLocationResponse: Codable {
    let objectId: String
    let createdAt: String
}

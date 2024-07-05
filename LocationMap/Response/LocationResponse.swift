//
//  LocationResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

struct LocationResponse: Codable {
    let condition: Int
    let error: String
}

extension LocationResponse: LocalizedError {
    var problemDescription: String{
        return error
    }
    
}

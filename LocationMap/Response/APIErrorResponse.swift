//
//  APIErrorResponse.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 05.07.24.
//


import Foundation

struct APIError: Codable, Error {
    let statusCode: Int
    let detail: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case detail = "detail"
    }
}

extension APIError: LocalizedError {
    var errorString: String{
        return detail
    }
    
}

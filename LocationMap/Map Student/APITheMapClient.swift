//
//  APITheMapClient.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

class TheMapAPIClient {
    
    enum Endpoints {
        static let baseURL = "https://onthemap-api.udacity.com/v1/"
        static let session = "session"
        static let learnerLocation = "LearnerLocation"
        
        case initiateSession
        case register
        case endSession
        case fetchLearnerLocations
        case retrieveUserData
        case submitLearnerLocation
        
        var urlString: String {
            switch self {
            case .initiateSession:
                return Endpoints.baseURL + Endpoints.session
            case .register:
                return "https://auth.udacity.com/sign-up"
            case .endSession:
                return Endpoints.baseURL + Endpoints.session
            case .fetchLearnerLocations:
                return Endpoints.baseURL + Endpoints.learnerLocation + "?limit=100&order=-updatedAt"
            case .retrieveUserData:
                return Endpoints.baseURL + "users/" + UserSession.customIdentifier
            case .submitLearnerLocation:
                return Endpoints.baseURL + Endpoints.learnerLocation
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    class func performGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func performPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, requestBody: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
  
    class func retrieveLearnerLocations(completion: @escaping ([LearnerLocation], Error?) -> Void) {
        performGETRequest(url: Endpoints.fetchLearnerLocations.url, responseType: LearnerLocationsResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }


    // Session creation function
    class func initiateSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let requestBody = SignInRequest(udacity: ["username": username, "password": password])
        performPOSTRequest(url: Endpoints.initiateSession.url, responseType: SignInResponse.self, requestBody: requestBody) { response, error in
            if let response = response {
                UserSession.sessionId = response.connection.id
                UserSession.customIdentifier = response.profile.identifier
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // Logout function
    class func endSession(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.endSession.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "XSRF-TOKEN" {
                    xsrfCookie = cookie
                }
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            UserSession.sessionId = ""
            UserSession.customIdentifier = ""
            completion(true, nil)
        }
        task.resume()
    }
    
    // Function to obtain user data
    class func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
        performGETRequest(url: Endpoints.retrieveUserData.url, responseType: UserAccountResponse.self) { response, error in
            if let response = response {
                UserSession.givenName = response.givenName ?? ""
                UserSession.familyName = response.familyName ?? ""
                UserSession.customIdentifier = response.userId ?? ""
                
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //  Function to post the student's location
    class func submitLearnerLocation(locationString: String, urlMedia: String, lat: Double, lon: Double, completion: @escaping (Bool, Error?) -> Void) {
        let requestBody = PlaceStudentRequest(
            uniqueIdentifier: UserSession.customIdentifier,
            givenName: UserSession.givenName,
            familyName: UserSession.familyName,
            locationString: locationString,
            urlMedia: urlMedia,
            lat: lat,
            lon: lon
        )
        performPOSTRequest(url: Endpoints.submitLearnerLocation.url, responseType: PostLocationResponse.self, requestBody: requestBody) { response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}

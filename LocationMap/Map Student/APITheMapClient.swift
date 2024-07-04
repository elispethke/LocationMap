//
//  APITheMapClient.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import Foundation

class APITheMapClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let session = "session"
        static let studentLocation = "StudentLocation"
        
        case createSession
        case signUp
        case logout
        case getStudentLocations
        case getUserData
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .createSession:
                return Endpoints.base + Endpoints.session
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .logout:
                return Endpoints.base + Endpoints.session
            case .getStudentLocations:
                return Endpoints.base + Endpoints.studentLocation + "?limit=100&order=-updatedAt"
            case .getUserData:
                return Endpoints.base + "users/" + Auth.objectId
            case .postStudentLocation:
                return Endpoints.base + Endpoints.studentLocation
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationsResponse.self) { (response: StudentLocationsResponse?, error: Error?) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SignInRequest(udacity: ["username": username, "password": password])
        taskForPOSTRequest(url: Endpoints.createSession.url, responseType: SignInResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.objectId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
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
            
            Auth.sessionId = ""
            Auth.objectId = ""
            completion(true, nil)
        }
        task.resume()
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, responseType: UserAccountResponse.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName ?? ""
                Auth.lastName = response.lastName ?? ""
                Auth.objectId = response.userId ?? ""
                
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }

    class func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = PlaceStudentRequest(
            uniqueKey: Auth.objectId,
            firstName: Auth.firstName,
            lastName: Auth.lastName,
            mapString: mapString,
            mediaURL: mediaURL,
            latitude: latitude,
            longitude: longitude
        )
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostLocationResponse.self, body: body) { response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}

//
//  SessionManager.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import Foundation
protocol APIEndpointRequest {
    func endpoint() -> String
}
var dictTask = [String:URLSessionDataTask]()
class SessionManager {
    struct ErrorResponse: Codable {
        let message:String
        let code : Int
    }
    enum APIError: Error {
        case invalidEndpoint
        case errorResponseDetected
        case noData
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(Codable)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
}
extension SessionManager {

    public static func get<R:Codable & APIEndpointRequest, T: Codable, E: Codable >(
        request:R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {
        //JSONEncoder().encode(APIBaseRequest(reqParam: request)).
       
        guard var endpointRequest = self.getUrlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "GET"
        
        if let similarSession = dictTask[request.endpoint()] {
            similarSession.cancel()
            dictTask.removeValue(forKey: request.endpoint())
        }
        
       let task =  URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                    dictTask.removeValue(forKey: request.endpoint())
                   self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
        })
        dictTask[request.endpoint()] = task
        task.resume()

    }


}

extension SessionManager {
    private static func getUrlRequest(from request:Codable & APIEndpointRequest)-> URLRequest? {

        
        let endpoint = request.endpoint()    
        guard var urlComponent = URLComponents(string: "\(Environment.baseUrl)\(endpoint)") else {
            return nil
        }
        urlComponent.setQueryItems(with: request.dictionary!)
        
        
        guard let endpointUrl = urlComponent.url else {
            return nil
        }
        let endpointRequest = URLRequest(url: endpointUrl)
        return endpointRequest
    }
}

extension SessionManager {
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {

        if let data = dataOrNil {
            do {
                let respsoneString = String(decoding: data, as: UTF8.self)
//                print(str)
                guard let responseData = respsoneString.data(using: .utf8) else {
                    return
                }

                let decodedResponse = try JSONDecoder().decode(T.self, from: responseData )
                onSuccess(decodedResponse)
            } catch {
                let originalError = error

                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    
                    onError(errorResponse, APIError.errorResponseDetected)
                } catch {
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
}
extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: Any]) {
        var queryItems = [URLQueryItem]()
        for (key,value) in parameters {
            let stringValue:String = "\(value)"
            queryItems.append(URLQueryItem(name: key, value: stringValue))
        }
        self.queryItems = queryItems//parameters.map { URLQueryItem(name: $0.key, value: $0.value as! String) }
    }
}


extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

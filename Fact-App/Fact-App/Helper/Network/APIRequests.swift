//
//  APIRequests.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import Foundation

struct APIRequestFact:Codable{
    
}
struct APIResponseFact:Codable{
    let title : String
    let rows : [Fact]
    
}
extension APIRequestFact:APIEndpointRequest {
    func endpoint() -> String {
        return APIEndpoints.fact
    }
    func dispatch(
        onSuccess successHandler: @escaping ((_: APIResponseFact) -> Void),
        onFailure failureHandler: @escaping ((_: SessionManager.ErrorResponse?, _: Error) -> Void)) {
        
        SessionManager.get(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
    
}

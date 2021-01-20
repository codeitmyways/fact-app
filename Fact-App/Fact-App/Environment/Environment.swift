//
//  Environment.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import Foundation
public enum Environment {
    // MARK:- Plist Keys
    enum Keys {
        enum Plist {
            static let rootUrl = "ROOT_URL"
        }
    }
    // MARK: - Plist Value
    private static let infoDictoinary : [String:Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        return dict
    }()
    
    // MARK: - Environment Values
    
    static let baseUrl : String  = {
        guard let baseUrlString = Environment.infoDictoinary[Keys.Plist.rootUrl] as? String else {
            fatalError("base url is not set for this environment")
        }
       return baseUrlString
    }()
    
}

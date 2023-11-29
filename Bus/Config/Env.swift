//
//  Env.swift
//  Bus
//
//  Created by Timothy on 29/11/23.
//

import Foundation

public struct Env {
    enum Keys {
        static let baseURL = "BASE_URL"
        static let test = "TEST"
    }
    
    // Get the BASE_URL
    static let baseURL: String = {
        guard let baseURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.baseURL
        ) as? String else {
            fatalError("BASE_URL not found")
        }
        return baseURLProperty
    }()
    
    static let test: String = {
        guard let res = Bundle.main.object(
            forInfoDictionaryKey: Keys.test
        ) as? String else {
            fatalError("TEST not found")
        }
        return res
    }()
}

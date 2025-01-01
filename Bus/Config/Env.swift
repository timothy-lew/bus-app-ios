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
        static let roadNameURL = "ROAD_NAME_URL"
        static let busNumberURL = "BUS_NUMBER_URL"
        static let busCodeURL = "BUS_CODE_URL"
        static let latLongURL = "LAT_LONG_URL"
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
    
    static let roadNameURL: String = {
        guard let roadNameURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.roadNameURL
        ) as? String else {
            fatalError("ROAD_NAME_URL not found")
        }
        return roadNameURLProperty
    }()
    
    static let busNumberURL: String = {
        guard let busNumberURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.busNumberURL
        ) as? String else {
            fatalError("BUS_NUMBER_URL not found")
        }
        return busNumberURLProperty
    }()
    
    static let busCodeURL: String = {
        guard let busCodeURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.busCodeURL
        ) as? String else {
            fatalError("BUS_CODE_URL not found")
        }
        return busCodeURLProperty
    }()
    
    static let latLongURL: String = {
        guard let latLongURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.latLongURL
        ) as? String else {
            fatalError("LAT_LONG_URL not found")
        }
        return latLongURLProperty
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

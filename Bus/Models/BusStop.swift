//
//  BusStop.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import Foundation

// cannot be class
struct BusStop: Codable, Hashable {
    let busStopCode: String
    let roadName: String
    let description: String
    let latitude: Double
    let longitude: Double
    
    // Structures being value types, don't neccessarily require an initializer defined
//    init(busStopCode: String, roadName: String, description: String, latitude: Double, longitude: Double) {
//        self.busStopCode = busStopCode
//        self.roadName = roadName
//        self.description = description
//        self.latitude = latitude
//        self.longitude = longitude
//    }
    
    enum CodingKeys: String, CodingKey {
        case busStopCode = "BusStopCode"
        case roadName = "RoadName"
        case description = "Description"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

//
//  BusStop.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import Foundation

//@Observable
// cannot be class
struct BusStop: Codable, Hashable {
    
    var busStopCode: String
    var roadName: String
    var description: String
    var latitude: Double
    var longitude: Double
    
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

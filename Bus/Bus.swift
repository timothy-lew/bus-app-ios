//
//  Bus.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import Foundation

import Foundation

struct BusArrival: Codable, Hashable {
    let odataMetadata: String
    let busStopCode: String
    let services: [BusService]

    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case busStopCode = "BusStopCode"
        case services = "Services"
    }
}

struct BusService: Codable, Hashable {
    let serviceNo: String
    let operatorName: String
    let nextBus: BusInfo
    let nextBus2: BusInfo
    let nextBus3: BusInfo

    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case operatorName = "Operator"
        case nextBus = "NextBus"
        case nextBus2 = "NextBus2"
        case nextBus3 = "NextBus3"
    }
}

struct BusInfo: Codable, Hashable {
    let originCode: String
    let destinationCode: String
    let estimatedArrival: String
    let latitude: String
    let longitude: String
    let visitNumber: String
    let load: String
    let feature: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case originCode = "OriginCode"
        case destinationCode = "DestinationCode"
        case estimatedArrival = "EstimatedArrival"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case visitNumber = "VisitNumber"
        case load = "Load"
        case feature = "Feature"
        case type = "Type"
    }
}

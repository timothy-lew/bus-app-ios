//
//  Utilities.swift
//  Bus
//
//  Created by Timothy on 1/12/23.
//

import Foundation
import SwiftUI

class Utilities {
    static func getBusStopsByRoadName(roadName: String, completion: @escaping ([BusStop]?, Error?) -> Void) {
        let url = URL(string: "\(Env.baseURL)/busstops/name/\(roadName)")!
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let busStopsDecoded = try JSONDecoder().decode([BusStop].self, from: data)
                completion(busStopsDecoded, nil)
            } catch {
                print("GET request failed: \(error.localizedDescription)")
                print(String(describing: error))
                completion(nil, error)
            }
        }
    }

    static func getBusStopByCode(busStopCode: String, completion: @escaping (BusStop?, Error?) -> Void) {
        let url = URL(string: "\(Env.baseURL)/busstop/code/\(busStopCode)")!
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let busStopDecoded = try JSONDecoder().decode(BusStop.self, from: data)
                completion(busStopDecoded, nil)
            } catch {
                print("GET request failed: \(error.localizedDescription)")
                print(String(describing: error))
                completion(nil, error)
            }
        }
    }
    
    static func getBusesByCode(busStopCode: String, completion: @escaping (BusArrival?, Error?) -> Void) {
        let url = URL(string: "\(Env.baseURL)/buses/code/\(busStopCode)")!
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let busesDecoded = try JSONDecoder().decode(BusArrival.self, from: data)
                completion(busesDecoded, nil)
            } catch {
                print("GET request failed: \(error.localizedDescription)")
                print(String(describing: error))
                completion(nil, error)
            }
        }
    }
    
    static func getBusStopsByLatLong(latitude: String, longitude: String, completion: @escaping ([BusStop]?, Error?) -> Void) {
        let url = URL(string: "\(Env.baseURL)/busstops/latlong/\(latitude)/\(longitude)")!
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                // response is array of json. [{BusStop}, {BusStop}]
                let busStopsDecoded = try JSONDecoder().decode([BusStop].self, from: data)
                completion(busStopsDecoded, nil)
            } catch {
                print("GET request failed: \(error.localizedDescription)")
                print(String(describing: error))
                completion(nil, error)
            }
        }
    }
    
    static func getBusTime(for estimatedArrival: String, load: String) -> some View {
        
        if estimatedArrival.isEmpty {
            return Text("NA").foregroundStyle(.primary)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        var timeDifference = 0.0
        var isArriving = false
        
        if let time = dateFormatter.date(from: estimatedArrival) {
            // Get the current date and time
            // 2023-11-25 12:38:55 +0000
            let currentDate = Date()
            
            // Calculate the time difference
            timeDifference = time.timeIntervalSince(currentDate) / 60
            if timeDifference <= 1 {
                isArriving = true
            }
        } else {
            print("Failed to parse the specific date: \(estimatedArrival)")
        }
        
        var colour: Color
        
        switch load {
            case "SEA": colour = .green
            case "SDA": colour = .orange
            case "LSD": colour = .red
            default: colour = .red
        }
        
        return isArriving ? Text("ARR").foregroundStyle(colour) : Text(String(Int(round(timeDifference)))).foregroundStyle(colour)
    }
}

//
//  BusStopView.swift
//  Bus
//
//  Created by Timothy on 26/11/23.
//

import SwiftUI

struct BusStopView: View {
    @State var busStop: BusStop
    
    var body: some View {
        HStack {
            Text("\(busStop.roadName)")
            Spacer()
            Text("\(busStop.description)")
        }
        .swipeActions {
            Button("Bookmark", systemImage: "star") {
                // TODO on 27 nov
                var busStops = UserDefaults.standard.data(forKey: "BusStopCodes") as? [String] ?? []
                busStops.append(busStop.busStopCode)
                UserDefaults.standard.set(busStops, forKey: "BusStopCodes")
                print(busStops)
            }
            .tint(.green)
        }
    }
}

#Preview {
    let busStop = BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2)
        
    return BusStopView(busStop: busStop)
}

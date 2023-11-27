//
//  Bookmark.swift
//  Bus
//
//  Created by Timothy on 26/11/23.
//

import SwiftUI

struct BookmarkView: View {
    @State var busStops: [BusStop]
    @State var buses: BusArrival
    
    var body: some View {
        List {
            ForEach(busStops, id: \.self) { busStop in
                NavigationLink {
                    BusView(busStop: busStop, buses: buses)
                } label : {
                    BusStopView(busStop: busStop)
                }
                
            }
        }
        .padding(.bottom, 20) // dont overlap with tab
    }
}

#Preview {
    let dummyBusStops: [BusStop] = [
            BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2),
        ]
    
    let busInfo1: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let busInfo2: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let busInfo3: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let busService: BusService = BusService(serviceNo: "962", operatorName: "SMRT", nextBus: busInfo1, nextBus2: busInfo2, nextBus3: busInfo3)
    
    let buses: BusArrival = BusArrival(odataMetadata: "test", busStopCode: "43911", services: [busService])
    
    return BookmarkView(busStops: dummyBusStops, buses: buses)
}

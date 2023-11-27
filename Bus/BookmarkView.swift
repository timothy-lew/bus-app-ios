//
//  Bookmark.swift
//  Bus
//
//  Created by Timothy on 26/11/23.
//

import SwiftUI

struct BookmarkView: View {
    @State var busStops: [BusStop]
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        List {
            ForEach(busStops, id: \.self) { busStop in
                NavigationLink {
                    BusView(busStop: busStop)
                } label : {
                    BusStopView(busStop: busStop)
                }
                
            }
        }
        .padding(.bottom, 20) // dont overlap with tab
    }
}

#Preview {
    let busStops: [BusStop] = [
            BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2),
        ]
    
    return BookmarkView(busStops: busStops)
}

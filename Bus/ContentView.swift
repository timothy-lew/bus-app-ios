//
//  ContentView.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var busStops = [BusStop]()
//    @State private var buses: BusArrival
    @State private var buses: BusArrival = BusArrival(odataMetadata: "", busStopCode: "", services: [])
    
    var body: some View {
        NavigationStack {
            TabView {
                BookmarkView(busStops: busStops, buses: buses)
                    // .badge(2)
                    .tabItem {
                        Label("Bookmarks", systemImage: "star")
                    }
                
                SearchView(busStops: busStops, buses: buses)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

//                SearchView()
//                    // .badge("!")
//                    .tabItem {
//                        Label("Account", systemImage: "person.crop.circle.fill")
//                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query(sort: \BookmarkBus.busStopCode, order: .forward, animation: .smooth) var codes: [BookmarkBus]
    
    @State private var isPresented = true
    
    var body: some View {
        NavigationStack {
            TabView {
                BookmarkView()
                    // .badge(2)
                    .tabItem {
                        Label("Bookmarks", systemImage: "star")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                NearbyView()
                    .tabItem {
                        Label("Nearby", systemImage: "location.fill")
                    }
            }
        }
        .alert("Swipe to bookmark or delete", isPresented: $isPresented) {
            Button("Ok") {
                isPresented.toggle()
            }
        }
    }
}

#Preview {
    return ContentView()
}

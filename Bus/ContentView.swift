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
    
    var body: some View {
        NavigationStack {
            Button("Debug") {
                print()
                for code in codes {
                    print(code.busStopCode)
                }
            }
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
            }
        }
    }
}

#Preview {
    return ContentView()
}

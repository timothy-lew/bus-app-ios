//
//  Bookmark.swift
//  Bus
//
//  Created by Timothy on 26/11/23.
//

import SwiftData
import SwiftUI

struct BookmarkView: View {
    @State private var busStops: [BusStop] = []
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Query(sort: \BookmarkBus.busStopCode, order: .forward, animation: .smooth) var bookmarkCodes: [BookmarkBus]
    
    var body: some View {
        List {
            ForEach(bookmarkCodes, id: \.busStopCode) { bookmarkCode in
                NavigationLink {
                    BusView(busStopCode: bookmarkCode.busStopCode)
                } label : {
                    BusStopView(busStopCode: bookmarkCode.busStopCode)
                }
            }
        }
        .onAppear(perform: {
            Task {
                await getBusStopsByCode()
            }
        })
        .padding(.bottom, 20) // dont overlap with tab
    }
    
    func getBusStopsByCode() async {
        busStops.removeAll() // Clear existing data before fetching
        for bookmarkCode in bookmarkCodes {
            // TODO add config
            // url
            let url = URL(string: "http://localhost:3000/busstop/code/\(bookmarkCode.busStopCode)")!
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let decodedData = try JSONDecoder().decode(BusStop.self, from: data)
                busStops.append(decodedData)
            } catch {
                print("GET request failed: \(error.localizedDescription)")
                print(String(describing: error))
                
                showAlert = true
                alertMessage = "Server error: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    BookmarkView()
}

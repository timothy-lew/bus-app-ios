//
//  BusStopView.swift
//  Bus
//
//  Created by Timothy on 26/11/23.
//

import SwiftData
import SwiftUI

struct BusStopView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \BookmarkBus.busStopCode, order: .forward, animation: .smooth) var bookmarkCodes: [BookmarkBus]
    
    @State private var busStop: BusStop = BusStop(busStopCode: "", roadName: "", description: "", latitude: 0.0, longitude: 0.0)
    @State var busStopCode: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        HStack {
            Text("\(busStop.roadName)")
            Spacer()
            Text("\(busStop.description)")
        }
        .onAppear(perform: {
            Task {
                await getBusStopByCode()
            }
        })
        .swipeActions {
            Button("Bookmark", systemImage: "star") {
                updateModelContext(isInsert: true)
            }
            .tint(.green)
            Button("Delete", systemImage: "trash", role: .destructive) {
                updateModelContext(isInsert: false)
            }
            .tint(.red)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Bookmark Status"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.easeInOut)
    }
    
    func getBusStopByCode() async {
        // TODO add config
        // url
        let url = URL(string: "http://localhost:3000/busstop/code/\(busStopCode)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedData = try JSONDecoder().decode(BusStop.self, from: data)
            busStop = decodedData
        } catch {
            print("GET request failed: \(error.localizedDescription)")
            print(String(describing: error))
            
            showAlert = true
            alertMessage = "Server error: \(error.localizedDescription)"
        }
    }
    
    func updateModelContext(isInsert: Bool) {
        if isInsert {
            let bookmarkBus = BookmarkBus(busStopCode: busStop.busStopCode)
            modelContext.insert(bookmarkBus)
        }
        else {
            for bookmarkCode in bookmarkCodes {
                if (bookmarkCode.busStopCode == busStop.busStopCode) {
                    modelContext.delete(bookmarkCode)
                }
            }
        }
        
        do {
            try modelContext.save()
            alertMessage = "Bookmark updated successfully!"
        } catch {
            print(error.localizedDescription)
            alertMessage = "Error updated bookmark: \(error.localizedDescription)"
        }
        showAlert = true
    }
}

#Preview {
//    let busStop = BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2)
        
    return BusStopView(busStopCode: "47611")
}

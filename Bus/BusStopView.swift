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
    
    @State var busStop: BusStop
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        HStack {
            Text("\(busStop.roadName)")
            Spacer()
            Text("\(busStop.description)")
        }
        .swipeActions {
            Button("Bookmark", systemImage: "star") {
                updateModelContext(busStop, isInsert: true)
            }
            .tint(.green)
            Button("Delete", systemImage: "trash", role: .destructive) {
                updateModelContext(busStop, isInsert: false)
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
    }
    
    func updateModelContext(_ busStop: BusStop, isInsert: Bool) {
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
            showAlert = true
            alertMessage = "Bookmark updated successfully!"
        } catch {
            print(error.localizedDescription)
            showAlert = true
            alertMessage = "Error updated bookmark: \(error.localizedDescription)"
        }
    }
}

#Preview {
    let busStop = BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2)
        
    return BusStopView(busStop: busStop)
}

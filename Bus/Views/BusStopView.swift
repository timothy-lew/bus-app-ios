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
    @State var distance: Int?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("\(busStop.description)")
                    .font(.title3).bold()
                Spacer()
            }
            HStack {
                Text("\(busStop.roadName)")
                    .italic()
                if let distance = distance {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 8, height: 8)
                    Text("\(String(distance))m")
                        .italic()
                }
                Spacer()
            }
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
        .alert("Bookmark Status", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .animation(.easeInOut)
    }
    
    func getBusStopByCode() async {
        let url = URL(string: "\(Env.baseURL)/busstop/code/\(busStopCode)")!
        
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
    return BusStopView(busStopCode: "47611")
}

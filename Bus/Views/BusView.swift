//
//  BusView.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftUI

struct BusView: View {
    @State private var busStop: BusStop = BusStop(busStopCode: "", roadName: "", description: "", latitude: 0.0, longitude: 0.0)
    @State private var buses: BusArrival = BusArrival(odataMetadata: "", busStopCode: "", services: [])
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var busStopCode: String
    
    var body: some View {
        VStack {
            List {
                ForEach(buses.services, id: \.self) { bus in
                    Section("\(bus.serviceNo)") {
                        HStack {
                            getBusTime(for: bus.nextBus.estimatedArrival, load: bus.nextBus.load)
                            Spacer()
                            getBusTime(for: bus.nextBus2.estimatedArrival, load: bus.nextBus2.load)
                            Spacer()
                            getBusTime(for: bus.nextBus3.estimatedArrival, load: bus.nextBus3.load)
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            Task {
                await getBusesByCode()
            }
        })
        .toolbar {
            ToolbarItem {
                Button("Refresh", systemImage: "gobackward") { // figure.run
                    Task {
                        await getBusesByCode()
                        print("refreshing")
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Server Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func getBusTime(for estimatedArrival: String, load: String) -> some View {
        if estimatedArrival.isEmpty {
            return Text("NA").foregroundStyle(.black)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        var timeDifference = 0.0
        var isArriving = false
        
        if let time = dateFormatter.date(from: estimatedArrival) {
            // Get the current date and time
            // 2023-11-25 12:38:55 +0000
            let currentDate = Date()
            
            // Calculate the time difference
            timeDifference = time.timeIntervalSince(currentDate) / 60
            if timeDifference <= 1 {
                isArriving = true
            }
        } else {
            print("Failed to parse the specific date: \(estimatedArrival)")
        }
        
        var colour = Color(.black)
        
        switch load {
            case "SEA": colour = .green
            case "SDA": colour = .orange
            case "LSD": colour = .red
            default: colour = .black
        }
        
        return isArriving ? Text("ARR").foregroundStyle(colour) : Text(String(Int(round(timeDifference)))).foregroundStyle(colour)
    }
    
    func getBusesByCode() async {
        let url = URL(string: "\(Env.baseURL)/buses/code/\(busStopCode)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            buses = try JSONDecoder().decode(BusArrival.self, from: data)
        } catch {
            print("GET request failed: \(error.localizedDescription)")
            print(String(describing: error))
            
            showAlert = true
            alertMessage = "Server error: \(error.localizedDescription)"
        }
    }
}

#Preview {
    return BusView(busStopCode: "47611")
}

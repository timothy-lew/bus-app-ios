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
        // TODO add config
        // url
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
//    let busStop: BusStop = BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2)
//    
//    let busInfo1: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
//    
//    let busInfo2: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
//    
//    let busInfo3: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
//    
//    let busService: BusService = BusService(serviceNo: "962", operatorName: "SMRT", nextBus: busInfo1, nextBus2: busInfo2, nextBus3: busInfo3)
//    
//    let buses: BusArrival = BusArrival(odataMetadata: "test", busStopCode: "43911", services: [busService])
        
    return BusView(busStopCode: "47611")
}

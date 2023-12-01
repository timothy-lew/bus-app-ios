//
//  BusView.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftUI

struct BusView: View {
    @State private var buses: BusArrival = BusArrival(odataMetadata: "", busStopCode: "", services: [])
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var busStopCode: String
    
    var body: some View {
        VStack {
            List {
                ForEach(buses.services, id: \.self) { bus in
                    Section("\(bus.serviceNo)") {
                        NavigationLink {
                            MapView(busStopCode: busStopCode, busNumber: bus.serviceNo, nextBus: bus.nextBus, nextBus2: bus.nextBus2, nextBus3: bus.nextBus3)
                        } label : {
                            HStack {
                                Utilities.getBusTime(for: bus.nextBus.estimatedArrival, load: bus.nextBus.load)
                                Spacer()
                                Utilities.getBusTime(for: bus.nextBus2.estimatedArrival, load: bus.nextBus2.load)
                                Spacer()
                                Utilities.getBusTime(for: bus.nextBus3.estimatedArrival, load: bus.nextBus3.load)
                            }
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
    
    func getBusesByCode() async {
        Utilities.getBusesByCode(busStopCode: busStopCode) { bus, error in
            if let bus = bus {
                buses = bus
            } else if let error = error {
                showAlert = true
                alertMessage = "Server error: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    return BusView(busStopCode: "47611")
}

//
//  SearchView.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftUI

//struct BusStops: Codable {
//    let busStops: [BusStop]
//}

//struct BusStopInfo: Codable {
//    let BusStopCode: String
//    let RoadName: String
//    let Description: String
//    let Latitude: Double
//    let Longitude: Double
//}

struct SearchView: View {
    @State private var roadName = ""
    
    @State var busStops: [BusStop]
    @State var buses: BusArrival
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Form {
                Section("Road Name") {
                    TextField("", text: $roadName, prompt: Text("Required"))
                        .onSubmit {
                            Task {
                                await getBusStopByRoadName()
                            }
                        }
//                        .onChange(of: roadName) {
//                            Task {
//                                await getBusStopByRoadName()
//                            }
//                        }
                        .disableAutocorrection(true)
                }
            }
            // if frame height not specified, Form{} will take up half the screen
            .frame(height: 100)
            
            // dk how to update list .onChange()
            List {
                ForEach(busStops, id: \.self) { busStop in
                    NavigationLink {
                        BusView(busStop: busStop, buses: buses)
//                            .onAppear(perform: {
//                                Task {
//                                    await getBusStopByCode(for: busStop)
//                                }
//                            })
                    } label : {
                        BusStopView(busStop: busStop)
                    }
                }
            }
            .padding(.bottom, 20) // dont overlap with tabview
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Server Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // not used
    func getBusStopByCode(for busStop: BusStop) async {
        // TODO add config
        // url
        let url = URL(string: "http://localhost:3000/busstop/number/\(busStop.busStopCode)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            buses = try JSONDecoder().decode(BusArrival.self, from: data)
        } catch {
            print("GET request failed: \(error.localizedDescription)")
            print(String(describing: error))
        }
    }
    
    func getBusStopByRoadName() async {
        print("HI")
        // TODO add config
        // url
        let url = URL(string: "http://localhost:3000/busstop/name/\(roadName)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            // response is array of json. [{BusStop}, {BusStop}]
            let busStopsDecoded = try JSONDecoder().decode([BusStop].self, from: data)
//            print(type(of: busStops))
            
            busStops = busStopsDecoded
        } catch {
            print("GET request failed: \(error.localizedDescription)")
            print(String(describing: error))
            
            showAlert = true
            alertMessage = "Server error: \(error.localizedDescription)"
        }
    }
}

#Preview {
    let dummyBusStops: [BusStop] = [
            BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2),
        ]
    
    let busInfo1: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let busInfo2: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let busInfo3: BusInfo = BusInfo(originCode: "46009", destinationCode: "46009", estimatedArrival: "This is arrival", latitude: "0.0", longitude: "0.0", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let busService: BusService = BusService(serviceNo: "962", operatorName: "SMRT", nextBus: busInfo1, nextBus2: busInfo2, nextBus3: busInfo3)
    
    let buses: BusArrival = BusArrival(odataMetadata: "test", busStopCode: "43911", services: [busService])
    
    return SearchView(busStops: dummyBusStops, buses: buses)
//    SearchView()
}

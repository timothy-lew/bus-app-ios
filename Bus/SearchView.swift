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
                        // .onChange
                        .disableAutocorrection(true)
                }
            }
            // if frame height not specified, Form{} will take up half the screen
            .frame(height: 100)
            
            // dk how to update list .onChange()
            List {
                ForEach(busStops, id: \.self) { busStop in
                    NavigationLink {
                        BusView(busStop: busStop)
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
    
    func getBusStopByRoadName() async {
        // TODO add config
        // url
        let url = URL(string: "http://localhost:3000/busstop/name/\(roadName)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // response is array of json. [{BusStop}, {BusStop}]
            let busStopsDecoded = try JSONDecoder().decode([BusStop].self, from: data)
            
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
    let busStops: [BusStop] = [
            BusStop(busStopCode: "123", roadName: "Woodlands", description: "Some Description", latitude: 1, longitude: 2),
        ]
    
    return SearchView(busStops: busStops)
}

//
//  SearchView.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftUI

struct SearchView: View {
    @State private var roadName = ""
    
    @State private var busStops: [BusStop] = []
 
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Form {
                Section("Road Name") {
                    HStack {
                        TextField("", text: $roadName, prompt: Text("Required"))
                            .onSubmit {
                                Task {
                                    await getBusStopsByRoadName()
                                }
                            }
                            .disableAutocorrection(true)
                        Button(action: {
                            roadName = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            // if frame height not specified, Form{} will take up half the screen
            .frame(height: 100)
            .scrollDisabled(true)
            Text("Swipe to bookmark or delete")
            
            // dk how to update list .onChange()
            List {
                ForEach(busStops, id: \.self) { busStop in
                    NavigationLink {
                        BusView(busStopCode: busStop.busStopCode)
                    } label : {
                        BusStopView(busStopCode: busStop.busStopCode)
                    }
                }
            }
            .padding(.bottom, 20) // dont overlap with tabview
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Server Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func getBusStopsByRoadName() async {
        if roadName.isEmpty {
            return
        }
        
        Utilities.getBusStopsByRoadName(roadName: roadName) { stops, error in
            if let stops = stops {
                busStops = stops
            } else if let error = error {
                showAlert = true
                alertMessage = "Server error: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    SearchView()
}

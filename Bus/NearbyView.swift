//
//  NearbyView.swift
//  Bus
//
//  Created by Timothy on 28/11/23.
//

import CoreLocation
import SwiftUI

struct NearbyView: View {
    @State private var userLocation: CLLocation?
    
    @ObservedObject var locationManager = LocationManager()

    @State var hasLocation = false
    
    @State private var latitude = ""
    @State private var longitude = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var busStops: [BusStop] = []
    
    var body: some View {
        VStack {
            if hasLocation {
                Text("Latitude: \(latitude), Longitude: \(longitude)")
            }
            else {
                Text("Location not available. Please enable location services.")
            }
            
            List {
                ForEach(busStops, id: \.self) { busStop in
                    NavigationLink {
                        BusView(busStopCode: busStop.busStopCode)
                    } label : {
                        BusStopView(busStopCode: busStop.busStopCode)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            locationManager.checkIfLocationServicesIsEnabled()
            test()
        }
        .toolbar {
            ToolbarItem {
                Button("Refresh", systemImage: "gobackward") { // figure.run
                    locationManager.checkIfLocationServicesIsEnabled()
                    test()
                    Task {
                        await getBusStopsByLatLong()
                    }
                }
            }
        }
    }
    
    func test() {
        print(locationManager.manager?.location ?? "Unable to get location")
        hasLocation = locationManager.manager?.location != nil
        if let currentLocation = locationManager.manager?.location {
            latitude = String(currentLocation.coordinate.latitude)
            longitude = String(currentLocation.coordinate.longitude)
        }
    }
    
    func getBusStopsByLatLong() async {
        // TODO add config
        // url
        let url = URL(string: "http://localhost:3000/busstops/latlong/\(latitude)/\(longitude)")!
        
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
    NearbyView()
}

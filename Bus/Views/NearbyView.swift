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
                        BusStopView(busStopCode: busStop.busStopCode, distance: busStop.distance)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            locationManager.checkIfLocationServicesIsEnabled()
            checkLocationManager()
        }
        .toolbar {
            ToolbarItem {
                Button("Refresh", systemImage: "gobackward") { // figure.run
                    locationManager.checkIfLocationServicesIsEnabled()
                    checkLocationManager()
                    Task {
                        await getBusStopsByLatLong()
                    }
                }
            }
        }
    }
    
    func checkLocationManager() {
//        print(locationManager.manager?.location ?? "Unable to get location")
        hasLocation = locationManager.manager?.location != nil
        if let currentLocation = locationManager.manager?.location {
            latitude = String(currentLocation.coordinate.latitude)
            longitude = String(currentLocation.coordinate.longitude)
        }
    }
    
    func getBusStopsByLatLong() async {
        Utilities.getBusStopsByLatLong(latitude: latitude, longitude: longitude) { stops, error in
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
    NearbyView()
}

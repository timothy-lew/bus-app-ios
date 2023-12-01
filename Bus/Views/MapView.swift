//
//  MapView.swift
//  Bus
//
//  Created by Timothy on 29/11/23.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var busStop = BusStop(busStopCode: "", roadName: "", description: "", latitude: 0.0, longitude: 0.0)
    @State private var showAlert = false
    @State private var alertMessage = ""
        
    // initial position is busStop coord
    var cameraPosition: MapCameraPosition {
        MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: busStop.latitude, longitude: busStop.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))
    }
        
    private var busStopCode: String
    private var busNumber: String
    private var nextBus: BusInfo
    private var nextBus2: BusInfo
    private var nextBus3: BusInfo
                 
    init(busStopCode: String, busNumber: String, nextBus: BusInfo, nextBus2: BusInfo, nextBus3: BusInfo) {
        self.busStopCode = busStopCode
        self.busNumber = busNumber
        self.nextBus = nextBus
        self.nextBus2 = nextBus2
        self.nextBus3 = nextBus3
    }
    
    var body: some View {        
        VStack {
            List {
                Section(busNumber) {
                    HStack {
                        Utilities.getBusTime(for: nextBus.estimatedArrival, load: nextBus.load)
                        Spacer()
                        Utilities.getBusTime(for: nextBus2.estimatedArrival, load: nextBus2.load)
                        Spacer()
                        Utilities.getBusTime(for: nextBus3.estimatedArrival, load: nextBus3.load)
                    }
                }
            }
            .frame(height: 100)
            
            // https://medium.com/simform-engineering/mapkit-swiftui-in-ios-17-1fec82c3bf00
            // https://www.wwdcnotes.com/notes/wwdc23/10043/
            // https://medium.com/appcoda-tutorials/working-with-mapkit-and-annotation-for-swiftui-f7c30c4f0da6
            Map(position: .constant(cameraPosition), bounds: nil, interactionModes: .all, scope: nil) {
                UserAnnotation()
                
                MapCircle(center: CLLocationCoordinate2D(latitude: Double(nextBus.latitude) ?? 0.0, longitude: Double(nextBus.longitude) ?? 0.0), radius: CLLocationDistance(100))
                    .foregroundStyle(.red.opacity(0.7))
                    .mapOverlayLevel(level: .aboveRoads)
                
                MapCircle(center: CLLocationCoordinate2D(latitude: Double(nextBus2.latitude) ?? 0.0, longitude: Double(nextBus2.longitude) ?? 0.0), radius: CLLocationDistance(100))
                    .foregroundStyle(.red.opacity(0.7))
                    .mapOverlayLevel(level: .aboveRoads)
                
                MapCircle(center: CLLocationCoordinate2D(latitude: Double(nextBus3.latitude) ?? 0.0, longitude: Double(nextBus3.longitude) ?? 0.0), radius: CLLocationDistance(100))
                    .foregroundStyle(.red.opacity(0.7))
                    .mapOverlayLevel(level: .aboveRoads)
            }
            .mapStyle(.standard) // standard, imagery, hybrid
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
        .onAppear() {
            Task {
                await getBusStopByCode()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Server Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
    }
    
    func getBusStopByCode() async {
        Utilities.getBusStopByCode(busStopCode: busStopCode) { stop, error in
            if let stop = stop {
                busStop = stop
            } else if let error = error {
                showAlert = true
                alertMessage = "Server error: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    let nextBus = BusInfo(originCode: "46009", destinationCode: "75009", estimatedArrival: "2023-11-29T17:10:45+08:00", latitude: "1.4396765", longitude: "103.79893", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let nextBus2 = BusInfo(originCode: "46009", destinationCode: "75009", estimatedArrival: "2023-11-29T17:15:41+08:00", latitude: "1.4409265", longitude: "103.80029716666667", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    let nextBus3 = BusInfo(originCode: "46009", destinationCode: "75009", estimatedArrival: "2023-11-29T17:10:45+08:00", latitude: "1.4396543333333334", longitude: "103.7975795", visitNumber: "1", load: "SEA", feature: "WAB", type: "DD")
    
    return MapView(busStopCode: "46009", busNumber: "969", nextBus: nextBus, nextBus2: nextBus2, nextBus3: nextBus3)
}

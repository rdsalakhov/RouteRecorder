//
//  LocationManager.swift
//  RouteRecorder
//
//  Created by Роман Салахов on 02.07.2020.
//  Copyright © 2020 Роман Салахов. All rights reserved.
//

import Foundation
//import Combine
import CoreLocation
import SwiftUI

class LocationManager : NSObject, ObservableObject  {
    private let locationManager = CLLocationManager()
    var record : Bool = true
    @Published var location : CLLocation? = nil
    @Published var locationList: [CLLocation] = []
    @Published private var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func startRecord() {
        self.record = true
    }
    
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.location = location
        
        if self.record {
            for newLocation in locations {
              let howRecent = newLocation.timestamp.timeIntervalSinceNow
              guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

              if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
              }

              locationList.append(newLocation)
            }
        }
        print(self.locationList.count)
    }
}

//
//  LocationManager.swift
//  RouteRecorder
//
//  Created by Роман Салахов on 02.07.2020.
//  Copyright © 2020 Роман Салахов. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationManager : NSObject, ObservableObject  {
    private let locationManager = CLLocationManager()
    @Published var location : CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.location = location
    }
}

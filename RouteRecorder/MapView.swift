//
//  MapView.swift
//  RouteRecorder
//
//  Created by Роман Салахов on 01.07.2020.
//  Copyright © 2020 Роман Салахов. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    enum Action {
        case idle
        case changeType(mapType: MKMapType)
    }
    
    @Binding var centerCoordinate : CLLocationCoordinate2D
    @Binding var action : Action
    
    @ObservedObject var locationManager = LocationManager()
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.centerCoordinate = self.centerCoordinate
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        switch action {
        case .idle:
            break
        case .changeType(let mapType):
            view.mapType = mapType
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), action: Binding<MapView.Action>(MapView.Action.idle))
//    }
//}

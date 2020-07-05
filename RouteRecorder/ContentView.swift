//
//  ContentView.swift
//  RouteRecorder
//
//  Created by Роман Салахов on 05.07.2020.
//  Copyright © 2020 Роман Салахов. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showMapSettings : Bool = false
    @State private var action : MapView.Action = .idle
    @State private var mapPickerSelection : Int = 0
     let pickerValues : [PickerValues] = [
        PickerValues(mapType: .standard, description: "Standard"),
        PickerValues(mapType: .hybrid, description: "Hybrid"),
        PickerValues(mapType: .satellite, description: "Satellite"),
    ]
    var body: some View {
        let binding = Binding<Int>(
            get: {self.mapPickerSelection},
            set: {newValue in
                self.action = .changeType(mapType: self.pickerValues[newValue].mapType)
                self.mapPickerSelection = newValue
            }
        )
        
        return ZStack {
            NavigationView {
                VStack{
                    MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), action: self.$action).offset()
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Map", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        withAnimation() {
                            self.showMapSettings.toggle()
                        }
                    }, label: {Image(systemName: "gear").imageScale(.large)}
                ))

            }
            if self.showMapSettings {
                    VStack(alignment: .center) {
                            VStack() {
                            Text("Map type")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                                
                            Picker(selection: binding, label: EmptyView()) {
                                ForEach (self.pickerValues.indices) {index in
                                    Text(self.pickerValues[index].description).tag(index)
                                }
                            }
                            .background(Color.white.opacity(0.65))
                            .cornerRadius(20)
                            .padding([.leading, .bottom, .trailing])
                                .pickerStyle(SegmentedPickerStyle())
                                .labelsHidden()
                                .multilineTextAlignment(.center)
                      
                            }
                            Spacer()

                    }
                    .background(
                    Color.black.opacity(0.65).onTapGesture {
                        withAnimation() {
                            self.showMapSettings.toggle()
                        }
                    }
                    .edgesIgnoringSafeArea(.all))
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom))
                    .offset(x:0, y:700)
            }
        }
    }
}
    
extension ContentView {
    struct PickerValues {
            let mapType: MKMapType
            let description: String
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

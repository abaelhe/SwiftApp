//
//  MapView.swift
//  SinglePhoto
//
//  Created by Abael He on 7/9/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var span:Double = 2.0
    var locationCoordinates: CLLocationCoordinate2D
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(
            center: locationCoordinates,
            span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        uiView.setRegion(region, animated: true)
    }
    
    func makeUIView(context:Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationCoordinates: landmarkExample.locationCoordinate)
    }
}

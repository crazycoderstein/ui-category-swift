//
//  MapViewSample.swift
//  BasicViews
//
//  Created by satoutakeshi on 2020/09/10.
//  Copyright © 2020 satoutakeshi. All rights reserved.
//

import SwiftUI
import MapKit

//https://swiftwithmajid.com/2020/07/29/using-mapkit-with-swiftui/

@available(iOS 14.0, *)
struct MapViewSample: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 25.7617,
            longitude: 80.1918
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
    }
}

@available(iOS 14.0, *)
struct MapViewSample_Previews: PreviewProvider {
    static var previews: some View {
        MapViewSample()
    }
}

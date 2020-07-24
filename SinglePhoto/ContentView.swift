//
//  ContentView.swift
//  SinglePhoto
//
//  Created by Abael He on 7/9/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private let sep = "\n"
    var body: some View {
        VStack {
            MapView(locationCoordinates: landmarkExample.locationCoordinate).edgesIgnoringSafeArea(.top)
                .frame(height: 150.0)
            CircleImage(image:ImageStore.shared.image(name:"avatar10")).offset(y:-150).padding(.bottom, -150.0)
                VStack(alignment: .leading) {
                    Text("🗽Swift.0.Abael.com")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                    HStack {
                        Text(/*@START_MENU_TOKEN@*/"Joshua Tree National Park"/*@END_MENU_TOKEN@*/)
                            .font(.headline)
                        Spacer()
                        Text(/*@START_MENU_TOKEN@*/"California"/*@END_MENU_TOKEN@*/)
                            .font(.headline)
                    }
                    LandmarkList()
                    //Text("🗽Swift:\(landmarkData.map{$0.desc}.joined(separator:sep))")

                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

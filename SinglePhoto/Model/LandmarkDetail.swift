//
//  LandmarkDetail.swift
//  SinglePhoto
//
//  Created by Abael He on 7/10/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import SwiftUI

struct LandmarkDetail: View{
    @EnvironmentObject var userData:UserData
    var landmark: Landmark
    var landmarkIndex:Int{userData.landmarks.firstIndex(where:{$0.id == landmark.id})!}
    var body: some View{
        VStack{
            MapView(locationCoordinates:landmark.locationCoordinate)
                .frame(height: 2 * landmark.height, alignment: .top)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .center){
                CircleImage(image: landmark.image, width: landmark.width, height: landmark.height)
                    .animation(
                        .interactiveSpring(response: 0.8, dampingFraction: 0.9, blendDuration: 0.9))
                    .animation(                        .interactiveSpring(response: 0.8, dampingFraction: 0.9, blendDuration: 0.9))
                VStack(spacing: 10.0){
                    HStack {
                        Text("\(landmark.id)")
                        Text(",")
                        Text(landmark.name)
                    }.font(.headline).animation(.easeIn(duration: 3.0))

                    Text(landmark.park)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Button(action: {
                        self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
                    }){
                        if self.userData.landmarks[self.landmarkIndex].isFavorite{
                            Image(systemName: "star.fill")
                        }else{
                            Image(systemName: "star")
                        }
                    }

                    Text(landmark.state)
                }
            }
            .padding(.vertical, -1.8 * landmark.height)
            .multilineTextAlignment(.leading)
            Spacer()
        }.navigationBarTitle(Text(landmark.name), displayMode: .inline)
    }
}


struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            LandmarkDetail(landmark: landmarkExample).environmentObject(UserData())
        }.preferredColorScheme(.dark)
    }
}

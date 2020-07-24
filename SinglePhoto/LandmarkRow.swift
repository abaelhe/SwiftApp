//
//  LandmarkRow.swift
//  SinglePhoto
//
//  Created by Abael He on 7/10/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack{
            landmark.image
                .resizable().scaledToFit().frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text("ID:\(landmark.id)")
                Text(landmark.name)
            }
            Spacer()
            if landmark.isFavorite{
                Image(systemName: "star.fill").imageScale(.large).foregroundColor(.yellow)
            }
            VStack(alignment: .trailing){
                Text(landmark.park)
                Text(landmark.state)
            }
            .font(.subheadline)
        }.foregroundColor(Color.purple)
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }.previewLayout(.fixed(width: 500, height: 100))
    }
}

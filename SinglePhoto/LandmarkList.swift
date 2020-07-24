//
//  LandmarkList.swift
//  SinglePhoto
//
//  Created by Abael He on 7/10/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import SwiftUI

struct LandmarkList:View {
    @EnvironmentObject var userData:UserData

    var body: some View {
        NavigationView {
// List(landmarkData){ landmark in //这种要Landmark遵循Identible
            List{
                Toggle(isOn: $userData.showFavoriatesOnly){
                    Text("Favorites Only")
                }
                ForEach(userData.landmarks){ landmark in
                //将LandmarkDetail作为destination传给NavigationLink作为链接
                    if !self.userData.showFavoriatesOnly || landmark.isFavorite {
                        NavigationLink(
                            destination:LandmarkDetail(landmark: landmark)
                            ){LandmarkRow(landmark:landmark)}
                    }
                }
            }
        }.navigationBarTitle(Text("🔭"), displayMode: .inline)
    }
}

struct LandmarkList_Previews: PreviewProvider {
//同时多设备预览效果;
    static var previews: some View {
        ForEach(0 ..< Devices.count){
            LandmarkList().environmentObject(UserData()).previewDevice(PreviewDevice(rawValue: Devices[$0])).preferredColorScheme(.light)
        }
    }
}

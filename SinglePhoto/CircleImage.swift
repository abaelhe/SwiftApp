//
//  CircleImage.swift
//  SinglePhoto
//
//  Created by Abael He on 7/9/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image:Image
    var width:CGFloat = 200.0
    var height:CGFloat = 200.0
    var body: some View {
        image.resizable().scaledToFit()
            .frame(width:width, height: height)
            .fixedSize(horizontal: true, vertical: true)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.green,lineWidth: 1))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image:ImageStore.shared.image(name:"avatar10")).preferredColorScheme(.dark)
    }
}

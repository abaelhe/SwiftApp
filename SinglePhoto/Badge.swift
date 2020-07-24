//
//  Badge.swift
//  SinglePhoto
//
//  Created by Abael He on 7/21/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI

struct Badge: View {
    static let rotationCount = 8
    
    var badgeSymbols: some View{
        ForEach(0..<Badge.rotationCount) { i in
            RotatedBadgeSymbol(angle: Angle(degrees:45.0*Double(i)))
                .opacity(0.5)
        }
    }
    
    var body: some View {
        ZStack {
            BadgeBackground()
            GeometryReader{geometry in
                self.badgeSymbols.scaleEffect(1.0/2.50, anchor: .top)
                    .position(
                        x:geometry.size.width/2.0,
                        y:(4.0/5.0)*geometry.size.height
                    )
            }
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}

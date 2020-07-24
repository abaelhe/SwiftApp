//
//  RotatedBadgeSymbol.swift
//  SinglePhoto
//
//  Created by Abael He on 7/22/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI

struct RotatedBadgeSymbol: View {
    let angle: Angle
    static var uiImage = UIImage(named: "avatar10")!

    var body: some View {
        BadgeSymbol()
            .rotationEffect(self.angle, anchor: .center)
    }
}

struct Arc: View {
    var center:CGPoint?
    var radius: CGFloat?
    var startDegrees:Double = 0.0
    var endDegrees:Double = 90.0
    var clockwise:Bool = true
    var transform:CGAffineTransform = CGAffineTransform.identity

    var body:some View{
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let diameter = min(width, height)
 
                path.addArc(
                    center: self.center ?? CGPoint(x:width/2.0, y:height/2.0),
                    radius: self.radius ?? diameter/2.0,
                    startAngle: Angle(degrees: self.startDegrees),
                    endAngle:Angle(degrees: self.endDegrees),
                    clockwise:self.clockwise,
                    transform: self.transform
                )

            }.moveDisabled(false)
        }
    }
}


struct Pentagon: View {
    func geoInternal(geometry: GeometryProxy) -> some View{
        let width = geometry.size.width
        let height = geometry.size.height
        let origin = CGPoint(x:0.0, y:0.0)
        let viewSight = CGPoint(x:width, y:height)
        let center = CGPoint(x:width/2.0, y:height/2.0)
        let leftBottom = CGPoint(x:0, y:height)
        let rightTop = CGPoint(x:width, y:0)

        return ZStack {
            Text("ÀAAAAAAAAAAAAAAAAAAAAAAA")
            Arc(center: center, radius:10.0)
        
        }
    }
    var body:some View{
        GeometryReader { geometry in
            self.geoInternal(geometry: geometry)
        }.rotationEffect(Angle(degrees: 0.0))
    }
}

struct RotatedBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        //ZStack是自后向前堆叠View Instannces
        ZStack{
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let origin = CGPoint(x:0.0, y:0.0)
                    let viewSight = CGPoint(x:width, y:height)
                    let center = CGPoint(x:width/2.0, y:height/2.0)
                    let leftBottom = CGPoint(x:0, y:height)
                    let rightTop = CGPoint(x:width, y:0)
                    let point = CGPoint(x:0.8*width, y:height*0.1)
                    path.move(to: origin)
                    path.addLines([origin,
                                   leftBottom, viewSight, rightTop])
                    }.opacity(0.1)
//                RotatedBadgeSymbol(angle: .init(degrees: 10))
                Pentagon()
               // Arc(center: CGPoint(x:100.0, y:100.0), radius:100.0)

//                RotatedBadgeSymbol.uiImage.view.clipShape(Circle())
//                    .position(CGPoint(
//                        x:geometry.size.width/2.0,
//                        y:geometry.size.height/2.0
//                    )).moveDisabled(false)
            }

        }
    }
}

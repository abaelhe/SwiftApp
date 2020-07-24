//
//  Badge.swift
//  SinglePhoto
//
//  Created by Abael He on 7/20/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI

struct BadgeBackground: View {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Path{ path in
                    let initValue:CGFloat = min(geometry.size.width, geometry.size.height)
                    var width:CGFloat = initValue, height:CGFloat = initValue

                    var xScale:CGFloat = 0.832
                    let xOffset = (width * (1.0 - xScale)) / 2.0
                    width *= xScale

                    var points:Array<CGPoint> = HexagonParameters.points.map{ segment in
                            CGPoint(
                            x: width * segment.useWidth.0 * segment.xFactors.0,
                            y:height * segment.useHeight.0 * segment.yFactors.0
                        )
                    }

                    //Path坐标系:左上(0,0), 右下(width, height)
                    path.move(to:points[0])

                    HexagonParameters.points.forEach{
                        let p:CGPoint = CGPoint(
                            x: width * $0.useWidth.0 * $0.xFactors.0,
                            y:height * $0.useHeight.0 * $0.yFactors.0
                        )
                        path.addLine(to: p)

                        path.addQuadCurve(
                            to: .init(
                                x: width * $0.useWidth.1 * $0.xFactors.1,
                                y: height * $0.useHeight.1 * $0.yFactors.1
                            ),
                            control: .init(
                                x: width * $0.useWidth.2 * $0.xFactors.2,
                                y: height * $0.useHeight.2 * $0.yFactors.2
                            )
                        )
                    }

                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                        startPoint: UnitPoint(x:0.5, y:0),
                        endPoint: UnitPoint(x:0.5, y:0.6)
                    )
                )
                .aspectRatio(1, contentMode: .fit)
                .offset(x: 30.0, y: 0.0)
                
                //Image("avatar10").clipShape(Circle())
            }
        }
    }
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}

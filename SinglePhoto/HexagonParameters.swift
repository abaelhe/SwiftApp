//
//  HexagonParameters.swift
//  SinglePhoto
//
//  Created by Abael He on 7/20/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import SwiftUI


struct HexagonParameters {
    struct Segment {
        let useWidth:(CGFloat, CGFloat, CGFloat)
        let xFactors:(CGFloat, CGFloat, CGFloat)
        let useHeight:(CGFloat, CGFloat, CGFloat)
        let yFactors:(CGFloat, CGFloat, CGFloat)
    }

    static var adjustment:CGFloat = 0.085
    static let points:[Segment] = [
        Segment(
            useWidth: (1.00, 1.00, 1.00),
            xFactors: (0.60, 0.40, 0.50),
            useHeight:(1.00, 1.00, 0.00),
            yFactors: (0.05, 0.05, 0.00)
        ),
        Segment(
            useWidth: (1.00, 1.00, 0.00),
            xFactors: (0.05, 0.00, 0.00),
            useHeight:(1.00, 1.00, 1.00),
            yFactors: (0.20+adjustment, 0.30+adjustment, 0.25+adjustment)
        ),
        Segment(
            useWidth: (1.00, 1.00, 0.00),
            xFactors: (0.00, 0.05, 0.00),
            useHeight:(1.00, 1.00, 1.00),
            yFactors: (0.70-adjustment, 0.80-adjustment, 0.75-adjustment)
        ),
        Segment(
            useWidth: (1.00, 1.00, 1.00),
            xFactors: (0.40, 0.60, 0.50),
            useHeight:(1.00, 1.00, 1.00),
            yFactors: (0.95, 0.95, 1.00)
        ),
        Segment(
            useWidth: (1.00, 1.00, 1.00),
            xFactors: (0.95, 1.00, 1.00),
            useHeight:(1.00, 1.00, 1.00),
            yFactors: (0.80-adjustment, 0.70-adjustment, 0.75-adjustment)
        ),
        Segment(
            useWidth: (1.00, 1.00, 1.00),
            xFactors: (1.00, 0.95, 1.00),
            useHeight:(1.00, 1.00, 1.00),
            yFactors: (0.30+adjustment, 0.20+adjustment, 0.25+adjustment)
        )
    ]
}


struct HexagonParameters_Previews: PreviewProvider {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    static var anchorPoint:UnitPoint = UnitPoint(x:0, y:0)

    static var previews: some View {
        GeometryReader { geometry in
            Path{ path in
                let initValue:CGFloat = min(geometry.size.width, geometry.size.height)
                var width:CGFloat = initValue, height:CGFloat = initValue

                let xScale:CGFloat = 0.832
                width *= xScale

                var points:Array<CGPoint> = HexagonParameters.points.map{
                    CGPoint(
                        x: width * $0.useWidth.0 * $0.xFactors.0,
                        y:height * $0.useHeight.0 * $0.yFactors.0
                    )
                }
                
                path.move(to: points[0])
                HexagonParameters.points.forEach{
                    path.addLine(to: CGPoint(
                        x: width * $0.useWidth.0 * $0.xFactors.0,
                        y:height * $0.useHeight.0 * $0.yFactors.0
                    ))
                    
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
                
            }.offsetBy(dx: 30.0, dy: 0.0)
            .fill(LinearGradient(
                gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x:0.5, y:0),
                endPoint: UnitPoint(x:0.5, y:0.6)
            ))
//            .rotationEffect(Angle(degrees: -8.0), anchor:.center)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

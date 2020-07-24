//
//  Data.swift
//  SinglePhoto
//
//  Created by Abael He on 7/10/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import CoreAudio
import CoreImage
import CoreML
//import CreateML
//import CreateMLUI


let landmarkData:[Landmark] = bundleJson(from:"landmarkData.json")
let landmarkExample:Landmark = landmarkData[0]
//let landmarkMLDataTable = MLDataTable
var Devices:Array<String>=[//要预先在Simulators上下载相应Models以preview用
//    "Mac"/*,*/
        "iPhone 11 Pro Max"
//        "iPhone 11 Pro",
//        "iPhone 11",
//        "iPhone 8 Plus",
//        "iPhone 8",
//        "iPad Pro (12.9-inch) (4th generation)",
//        "iPad Air (3th generation)",
//        "iPad (7th generation)",

//        "iPhone 7",
//        "iPhone 7 Plus",
//        "iPhone 8",
//        "iPhone 8 Plus",
//        "iPhone SE",
//        "iPhone X",
//        "iPhone Xs",
//        "iPhone Xs Max",
//        "iPhone Xʀ",
//        "iPad mini 4",
//        "iPad Air 2",
//        "iPad Pro (9.7-inch)",
//        "iPad Pro (12.9-inch)",
//        "iPad (5th generation)",
//        "iPad Pro (12.9-inch) (2nd generation)",
//        "iPad Pro (10.5-inch)",
//        "iPad (6th generation)",
//        "iPad Pro (11-inch)",
//        "iPad Pro (12.9-inch) (3rd generation)",
//        "iPad mini (5th generation)",
//        "iPad Air (3rd generation)",
//        "Apple TV",
//        "Apple TV 4K",
//        "Apple TV 4K (at 1080p)",
//        "Apple Watch Series 2 - 38mm",
//        "Apple Watch Series 2 - 42mm",
//        "Apple Watch Series 3 - 38mm",
//        "Apple Watch Series 3 - 42mm",
//        "Apple Watch Series 4 - 40mm",
//        "Apple Watch Series 4 - 44mm"
]

public func bundleCGImage(from filename:String) -> CGImage{
    guard let uiimage = UIImage(named: filename),
        let cgimage = uiimage.cgImage
    else{
        fatalError("Error load Bundle image:\(filename)")
    }
    return cgimage
}


public func bundleJson<T:Decodable>(from filename:String) -> T{
    let data:Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else{
        fatalError("Error finding data file:\(filename)")
    }
    
/*
    import Foundation
    import SwiftUI
    var filename = "landmarkData.json"
    let file = URL(fileURLWithPath: filename)
    let data:Data = try! Data(contentsOf: file)
    let decoder = JSONDecoder()
    let r = try! decoder.decode(Array<Landmark>.self, from: data)
*/
    do{
        data = try Data(contentsOf: file)
    }catch{
        fatalError("Error reading data file:\(filename)")
    }
    let decoder = JSONDecoder()
//    do{
        return try! decoder.decode(T.self, from: data)
//    }catch{
//        fatalError("Error parsing data in file:\(filename)")
//    }
}

extension UIImage{
    var view:Image{
        Image(uiImage: self)
    }
}

extension Angle{
    public static func +(lhs:Angle, delta:Int) -> Angle{
        return Angle(degrees: lhs.degrees + Double(delta))
    }
    public static func +(lhs:Angle, delta:Double) -> Angle{
        return Angle(degrees: lhs.degrees + delta)
    }
    public static func -(lhs:Angle, delta:Double) -> Angle{
        return Angle(degrees: lhs.degrees - delta)
    }
    public static func -(lhs:Angle, delta:Int) -> Angle{
        return Angle(degrees: lhs.degrees - Double(delta))
    }
    public static func *(lhs:Angle, delta:Double) -> Angle{
        return Angle(degrees: lhs.degrees * delta)
    }
    public static func *(lhs:Angle, delta:Int) -> Angle{
        return Angle(degrees: lhs.degrees * Double(delta))
    }

}

final class ImageStore{
    typealias _ImageDirectory = [String:CGImage]
    fileprivate var images: _ImageDirectory = [:]
    
    fileprivate static var scale = 2
    static var shared = ImageStore()
    
    func image(name:String) -> Image{
        let index = _guaranteeImage(name:name)
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }
    fileprivate func _guaranteeImage(name:String) -> _ImageDirectory.Index{
        if let index = images.index(forKey: name){return index}
        images[name] = bundleCGImage(from:name)
        return images.index(forKey: name)!
    }
}

struct Data_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            landmarkExample.image
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text("\(landmarkExample.id)")
                Text(landmarkExample.name)
            }
            Spacer()
        }.preferredColorScheme(.dark)
    }
}

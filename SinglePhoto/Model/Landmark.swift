//
//  Landmark.swift
//  SinglePhoto
//
//  Created by Abael He on 7/10/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

typealias RawDatable = Hashable & Codable & Equatable
struct Coordinates:RawDatable{
    public var latitude: CLLocationDegrees
    public var longitude: CLLocationDegrees
}

enum Category:String, CaseIterable, RawDatable{
    case featured = "Featured"
    case lakes = "Lakes"
    case rivers = "Rivers"
    case mountains = "Mountains"
    case other
}
//1. Identifiable协议用来为SwiftUI的List(a:Landmark)提供id(通用型)
//2. 也可用SwiftUI的List(landmarkData, \.id){ landmark in ... }用 Int类型的 .id作为id
class Landmark: RawDatable, Identifiable{
// Binding support
//    struct BindingBool{@Binding var active:Bool}
//    var binding:BindingBool = BindingBool(active:Binding.constant(true))
//    var active:Bool {
//        get{self.binding.active}
//        set{self.binding.active = newValue}
//    }

    // Equatable
    static func == (lhs: Landmark, rhs: Landmark) -> Bool {
        return lhs.state == rhs.state
        && lhs.park == rhs.park
        && lhs.name == rhs.name
    }
    // Hashable
    func hash(into hasher: inout Hasher) {
          hasher.combine(state)
          hasher.combine(park)
          hasher.combine(name)
    }
    //
    init(category: Category,
         id:Int,
         name:String,
         imageName:String,
         coordinates:Coordinates,
         state:String,
         park:String,
         width:CGFloat = 200.0,
         height:CGFloat = 200.0,
         active:Bool = true
         ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.state = state
        self.park = park
        self.width = width
        self.height = height
        self.category = category
        self.coordinates = coordinates
        self.active = active
    }

    // Encodable | Decodable
    enum CodingKeys:String, CodingKey, CaseIterable{
        case id
        case category
        case name
        case imageName
        case coordinates
        case state
        case park
        case isFavorite
        case width
        case height
    }
    enum AdditionalInfoKeys: String, CodingKey, CaseIterable{
        case width
        case height
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category, forKey: .category)
        try container.encode(name, forKey: .name)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(state, forKey: .state)
        try container.encode(park, forKey: .park)
        //Landmark有width和height属性，因此直接将width和height编进container
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        imageName = try values.decode(String.self, forKey: .imageName)
        state = try values.decode(String.self, forKey: .state)
        park = try values.decode(String.self, forKey: .park)
        category = try values.decode(Category.self, forKey: .category)
        coordinates = try values.decode(Coordinates.self, forKey: .coordinates)
        
        //例如JSON有的有width和height字段，有的没有；的处理情形
        //外部JSON值可能为任意值，因此在width和height的didSet内实现了有效值为 > 200
        if values.contains(.width), let _width = try values.decodeIfPresent(CGFloat.self, forKey: .width){
            width = max(_width, 200.0)//此处构造函数阶段，必须要用max()保证 >= 200
            //因为构造函数阶段完成以后didSet才能保证设置width新值后 >= 200
        }
        if values.contains(.height), let _height = try values.decodeIfPresent(CGFloat.self, forKey: .height){
            height = max(_height, 200)//此处构造函数阶段，必须要用max()保证 >= 200
            //因为构造函数阶段完成以后didSet才能保证设置height新值后 >= 200
        }

        if values.contains(.isFavorite), let _isFavorite = try values.decodeIfPresent(Bool.self, forKey: .isFavorite){
            isFavorite = _isFavorite
        }

    }

    var id:Int
    var name:String
    var imageName:String
    var state:String
    var park:String
    var width:CGFloat = 200.0 {didSet{if width < 200.0{width=200.0}}}
    var height:CGFloat = 200.0 {didSet{if height < 200.0{height=200.0}}
    }
    var category: Category{didSet{self.active = (self.category == Category.mountains)}}
    fileprivate var coordinates:Coordinates
    var active:Bool = true
    var isFavorite:Bool = false

    //computed property
    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
}

extension Landmark{
    var desc:String{"[\(id)]:\(imageName)"}
    var image:Image{ImageStore.shared.image(name: imageName)}
}

struct Landmark_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Group {
            Text("Hello, World!")
        }.preferredColorScheme(.dark)/*@END_MENU_TOKEN@*/
    }
}

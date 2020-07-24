import Foundation
import SwiftUI
import CoreLocation

#if targetEnvironment(macCatalyst)
import UIKit
#endif
import AppKit
//import PathKit

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

class Landmark: RawDatable, Identifiable{
        struct BindingBool{@Binding var active:Bool}
    var binding:BindingBool = BindingBool(active:Binding.constant(true))
    var active:Bool {
        get{self.binding.active}
        set{self.binding.active = newValue}
    }

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
    }

    var id:Int
    var name:String
    var imageName:String
    var state:String
    var park:String
    var width:CGFloat = 200.0
    var height:CGFloat = 200.0
    var category: Category{didSet{self.binding.active = (self.category == Category.mountains)}}
    fileprivate var coordinates:Coordinates
   

    var locationCoordinate: CLLocationCoordinate2D{//computed property
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum CodingKeys:String, CodingKey, CaseIterable{
        case id
        case category
        case name
        case imageName
        case coordinates
        case state
        case park
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
        
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(height, forKey: .height)
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
        
        if values.contains(.width), let _width = try values.decodeIfPresent(CGFloat.self, forKey: .width){
            print("width:\(width), \(_width)")
            width = _width
        }
        if values.contains(.height), let _height = try values.decodeIfPresent(CGFloat.self, forKey: .height){
            print("height:\(height), \(_height)")
            height = _height
        }
    }
}

public func bundleJson<T:Decodable>(from filename:String) -> T{
    //var filename = "landmarkData.json"
    let file = URL(fileURLWithPath: filename)
    let data:Data = try! Data(contentsOf: file)
    let decoder = JSONDecoder()
    let v = try! decoder.decode(Array<Landmark>.self, from: data)
    return v as! T
}

let va:[Landmark] = bundleJson(from: "landmarkData.json")

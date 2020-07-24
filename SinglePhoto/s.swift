import Foundation
import SwiftUI
import CoreLocation
import CoreAudio
import CoreImage
import CoreML

public func bundleImage(from filename:String) -> CGImage{
    guard let url = Bundle.main.url(forResource: filename, withExtension: "jpg"),
        let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
        let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    else{
        fatalError("Error load Bundle image:\(filename)")
    }
    return image
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
        if let index = images.index(forKey: name){
            return index
        }
        images[name] = bundleImage(from:name)
        return images.index(forKey: name)!
    }
}


typealias RawDatable = Hashable & Codable & Equatable
struct Coordinates: RawDatable {
    var latitude:Double
    var longitude:Double
}

enum Category:String, CaseIterable, RawDatable{
    case featured = "Featured"
    case lakes = "Lakes"
    case rivers = "Rivers"
    case mountains = "Mountains"
    case other = "nil"
}

struct Landmark: RawDatable {
    var category: Category
    var id:Int
    var name:String
    fileprivate var imageName:String
    fileprivate var coordinates:Coordinates
    var state:String
    var park:String

    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    var desc:String{"[\(id)]\(name):\(imageName)"}
}



extension Landmark{
    var image:Image{
        ImageStore.shared.image(name: imageName)
    }
}




    import Foundation
    import SwiftUI
    var filename = "landmarkData.json"
    let file = URL(fileURLWithPath: filename)
print(file)
    let data:Data = try! Data(contentsOf: file)
    let decoder = JSONDecoder()

let r = try! decoder.decode(Array<Landmark>.self, from: data)


print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
let vk:Bool? = true
let va = Binding.constant(true)
let vb = Binding.constant(vk)
struct V{
    //@Binding(get:{.wrappedValue}, set:{ newValue in .wrappedValue=newValue}) var v:Int //
    @Binding var v:Bool
    @Binding var vc:Bool?
}
let a = V(v:va, vc:vb)
print("result:\(a)")

print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
var ki:Bool? = true
struct LandmarkList {
    //@Binding(Binding.constant(ki)) var active:Bool
    @Binding var active:Bool // = Binding.constant(ki)
}
var ka = LandmarkList(active: Binding.constant(true))
print("KA:\(ka.$active)")
print("KA:\(ka.active)")




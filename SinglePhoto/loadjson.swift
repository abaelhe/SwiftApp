import Foundation
import SwiftUI

public func localJson<T:Decodable>(from filename:String) -> T{
        let data:Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else{
            fatalError("Error finding data file:\(filename)")
        }
        do{
            data = try Data(contentsOf: file)
        }catch{
            fatalError("Error reading data file:\(filename)")
        }
        do{
            let decoder = JSONDecoder()
            let json = try decoder.decode(T.self, from: data)
            return json
        }catch{
            fatalError("Error parsing data in file:\(filename)")
        }
}

let jso:[Any] = localJson("landmarkData.json")

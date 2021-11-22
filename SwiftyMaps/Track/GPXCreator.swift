//
//  GPXCreator.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import Foundation
import CoreLocation

class GPXCreator : NSObject{
    
    func createFile(url: URL, locations: [CLLocation]) -> Bool{
        let s = ""
        if let data = s.data(using: .utf8){
            return FileController.saveFile(data : data, url: url)
        }
        return false
    }
    
}


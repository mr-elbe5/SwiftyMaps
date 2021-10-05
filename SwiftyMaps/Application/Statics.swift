//
//  ViewStatics.swift
//
//  Created by Michael Rönnau on 21.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct Statics{
    
    static var tabColor : UIColor = .systemGray6
    
    static var defaultInset : CGFloat = 10
    
    static var defaultInsets : UIEdgeInsets = .init(top: defaultInset, left: defaultInset, bottom: defaultInset, right: defaultInset)
    
    static var flatInsets : UIEdgeInsets = .init(top: 0, left: defaultInset, bottom: 0, right: defaultInset)
    
    static var narrowInsets : UIEdgeInsets = .init(top: defaultInset, left: 0, bottom: defaultInset, right: 0)
    
    static var reverseInsets : UIEdgeInsets = .init(top: -defaultInset, left: -defaultInset, bottom: -defaultInset, right: -defaultInset)
    
    static var doubleInsets : UIEdgeInsets = .init(top: 2 * defaultInset, left: 2 * defaultInset, bottom: 2 * defaultInset, right: 2 * defaultInset)
    
    static var backupDir : String = "backups"
    
    static var exportDir : String = "export"
    
    static var backupOfName : String = "backup_of_"
    
    static var backupName : String = "backup_"
    
    static var backgroundName : String = "background."
    
    static var startRadius : Double = 10000
    
    static var cartoUrl = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    static var topoUrl = "https://maps.elbe5.de/topo/{z}/{x}/{y}.png"
    
    static var cameraAngle : Double = 0.26114827778041366
    static var cameraTan : Double = tan(cameraAngle)
    static var tilesSize : Int = 3500
    
    static func zoomLevel(from size: CGSize, span: MKCoordinateSpan) -> Double{
        log2(Double(360 * size.width) / (span.longitudeDelta * 128))
    }
    
    /*
    zoom 6: distance 5000000
    zoom 7: distance 2000000
    zoom 8: distance 1000000
    zoom 9: distance 5000000
    zoom 10: distance 250000
    zoom 11: distance 125000
    zoom 12: distance 60000
    zoom 13: distance 30000
    zoom 14: distance 15000
    zoom 15: distance 7000
    zoom 16: distance 3500
    zoom 17: distance 1750
    zoom 18: distance 900
    zoom 19: distance 450
    zoom 20: distance 225
    zoom 21: distance 100
    */
    
    static var privateURL : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
}


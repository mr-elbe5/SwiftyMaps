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
    
    static func latitudeMeters(from latitudeDelta: Double) -> Double{
        latitudeDelta * 111000
    }
    
    static func cameraDistance(from latitudeDelta: Double) -> Double{
        // latitude meters/2 / dist = cameraTan
        return round(latitudeMeters(from: latitudeDelta)/2/cameraTan)
    }
    
    static func zoomLevel(from size: CGSize, longitudeDelta: Double) -> Double{
       log2(Double(360 * size.width) / (longitudeDelta * 128))
    }
    
    static func zoomLevel(from size: CGSize, latitudeDelta: Double) -> Double{
       log2(Double(360 * size.height) / (latitudeDelta * 128))
    }
    
    static func zoomLevel(from size: CGSize, span: MKCoordinateSpan) -> Double{
        let sizeDiag = sqrt(size.width*size.width + size.height*size.height)
        let deltaDiag = sqrt(span.latitudeDelta*span.latitudeDelta + span.longitudeDelta*span.longitudeDelta)
        return log2(Double(360 * sizeDiag) / (deltaDiag * 128))
    }
    
    static func distance(zoom: Int) -> Double{
        switch zoom{
        case 6: return 5319214
        case 7: return 2727606
        case 8: return 1401332
        case 9: return 695556
        case 10: return 353327
        case 11: return 174954
        case 12: return 87467
        case 13: return 43509
        case 14: return 21904
        case 15: return 10707
        case 16: return 5419
        case 17: return 2756 // 2533 2653
        case 18: return 1367 // 1356 1349 1087?
        case 19: return 688 // 686 688 665
        case 20: return 341 // 337
        case 21: return 152 // 164
        default:
            return 0
        }
    }
    
    static var privateURL : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
}


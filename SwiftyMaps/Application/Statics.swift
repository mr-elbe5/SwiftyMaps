//
//  ViewStatics.swift
//
//  Created by Michael Rönnau on 21.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

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
    
}

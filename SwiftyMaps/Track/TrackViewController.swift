//
//  TrackViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 20.09.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

class TrackViewController: PopupViewController{
    
    var track : TrackData? = nil
    
    override func loadView() {
        title = "track".localize()
        super.loadView()
        
        
    }
    
    
    
}

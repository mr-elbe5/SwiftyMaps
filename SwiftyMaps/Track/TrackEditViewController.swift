//
//  TrackEditViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 23.11.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

class TrackEditViewController: PopupViewController{
    
    var track : TrackData? = nil
    
    override func loadView() {
        title = "track".localize()
        super.loadView()
        
        
    }
    
    
    
}

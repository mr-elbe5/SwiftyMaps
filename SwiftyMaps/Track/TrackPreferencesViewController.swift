//
//  TrackPreferencesViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol TrackPreferencesDelegate{
    
}

class TrackPreferencesViewController: PopupViewController{
    
    var delegate : TrackPreferencesDelegate? = nil
    
    override func loadView() {
        title = "trackPreferences".localize()
        super.loadView()
        
    }
    
}


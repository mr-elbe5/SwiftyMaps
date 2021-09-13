//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit
import MapKit
import SwiftyIOSViewExtensions

class MainViewController: MapViewController {
    
    var headerView = UIView()
    
    var isTracking : Bool = false

    override func loadView() {
        super.loadView()
        LocationService.shared.checkRunning()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(guide.topAnchor, inset: .zero)
                .trailing(guide.trailingAnchor, inset: .zero)
        headerView.backgroundColor = .black
        fillMenu(menuView: headerView)
        mkMapView.mapType = .standard
        mkMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mkMapView.showsCompass = true
        mkMapView.showsScale = true
        mkMapView.delegate = self
        view.addSubview(mkMapView)
        mkMapView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(headerView.bottomAnchor, inset: 1)
                .trailing(guide.trailingAnchor, inset: .zero)
                .bottom(guide.bottomAnchor, inset: .zero)
        applySettings()
    }
    
    func applySettings(){
        mkMapView.showsUserLocation = Settings.shared.showUserLocation
    }
    
    func updateSettings(){
        Settings.shared.showUserLocation = mkMapView.showsUserLocation
    }
    
}

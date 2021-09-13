//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit
import MapKit
import SwiftyIOSViewExtensions

extension MainViewController {
    
    func fillMenu(menuView: UIView) {
        let styleButton = IconButton(icon: "map")
        styleButton.tintColor = .white
        styleButton.menu = getStyleMenu()
        styleButton.showsMenuAsPrimaryAction = true
        menuView.addSubview(styleButton)
        let tourButton = IconButton(icon: "figure.walk")
        tourButton.tintColor = .white
        tourButton.addTarget(self, action: #selector(toggleTracking), for: .touchDown)
        menuView.addSubview(tourButton)
        let pinButton = IconButton(icon: "mappin.and.ellipse")
        pinButton.tintColor = .white
        pinButton.addTarget(self, action: #selector(setPin), for: .touchDown)
        menuView.addSubview(pinButton)
        let cameraButton = IconButton(icon: "camera")
        cameraButton.tintColor = .white
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        menuView.addSubview(cameraButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.tintColor = .white
        infoButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        menuView.addSubview(infoButton)
        let configButton = IconButton(icon: "slider.horizontal.3")
        configButton.tintColor = .white
        configButton.menu = getConfigMenu()
        configButton.showsMenuAsPrimaryAction = true
        menuView.addSubview(configButton)

        styleButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .leading(menuView.leadingAnchor, inset: defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)

        tourButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .centerX(menuView.centerXAnchor)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        pinButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .trailing(tourButton.leadingAnchor, inset: 2 * defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)
        cameraButton.setAnchors()
                .top(menuView.topAnchor, inset: defaultInset)
                .leading(tourButton.trailingAnchor, inset: 2 * defaultInset)
                .bottom(menuView.bottomAnchor, inset: defaultInset)

        infoButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .trailing(menuView.trailingAnchor, inset: defaultInset)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
        configButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .trailing(infoButton.leadingAnchor, inset: 2 * defaultInset)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
    }

    func getStyleMenu() -> UIMenu{
        let standardMapAction = UIAction(title: "defaultMapStyle".localize()) { action in
            self.setMapType(.standard)
        }
        let osmMapAction = UIAction(title: "openStreetMapStyle".localize()) { action in
            self.setMapType(.openStreetMap)
        }
        let topoMapAction = UIAction(title: "openTopoMapStyle".localize()) { action in
            self.setMapType(.openTopoMap)
        }
        let satelliteAction = UIAction(title: "satelliteMapStyle".localize()) { action in
            self.setMapType(.satellite)
        }
        return UIMenu(title: "", children: [standardMapAction, osmMapAction, topoMapAction, satelliteAction])
    }

    func getConfigMenu() -> UIMenu{
        let settingsAction = UIAction(title: "settings".localize(), image: UIImage(systemName: "gearshape")) { action in
            self.openSettings()
        }
        let exportAction = UIAction(title: "export".localize(), image: UIImage(systemName: "square.and.arrow.up")) { action in
            self.openExport()
        }
        return UIMenu(title: "", children: [settingsAction, exportAction])

    }

    

    @objc func openCamera(){

    }

    @objc func setPin(){

    }
    
    @objc func toggleTracking(sender: Any){
        guard let sender = sender as? UIButton else { return }
        if isTracking{
            isTracking = false
            sender.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        }
        else{
            isTracking = true
            sender.setImage(UIImage(systemName: "figure.stand"), for: .normal)
        }
    }

    func openSettings(){

    }

    func openExport(){

    }

    private func drawPins(){

    }
    
}

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
        styleButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .leading(menuView.leadingAnchor, inset: defaultInset)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
        let pinButton = IconButton(icon: "mappin")
        pinButton.tintColor = .white
        pinButton.menu = getPinMenu()
        pinButton.showsMenuAsPrimaryAction = true
        menuView.addSubview(pinButton)
        pinButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .leading(styleButton.trailingAnchor, inset: 2 * defaultInset)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
        let tourButton = IconButton(icon: "figure.walk")
        tourButton.tintColor = .white
        tourButton.menu = getTourMenu()
        tourButton.showsMenuAsPrimaryAction = true
        menuView.addSubview(tourButton)
        tourButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .leading(pinButton.trailingAnchor, inset: 2 * defaultInset)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
        let cameraButton = IconButton(icon: "camera")
        cameraButton.tintColor = .white
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        menuView.addSubview(cameraButton)
        cameraButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .centerX(menuView.centerXAnchor)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.tintColor = .white
        infoButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        menuView.addSubview(infoButton)
        infoButton.setAnchors()
            .top(menuView.topAnchor, inset: defaultInset)
            .trailing(menuView.trailingAnchor, inset: defaultInset)
            .bottom(menuView.bottomAnchor, inset: defaultInset)
        let configButton = IconButton(icon: "slider.horizontal.3")
        configButton.tintColor = .white
        configButton.menu = getConfigMenu()
        configButton.showsMenuAsPrimaryAction = true
        menuView.addSubview(configButton)
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

    func getPinMenu() -> UIMenu{
        let setPinAction = UIAction(title: "setPin".localize(), image: UIImage(systemName: "mappin.and.ellipse")) { action in
            self.setPin()
        }
        let removePinAction = UIAction(title: "removePin".localize(), image: UIImage(systemName: "mappin.slash")) { action in
            self.removePin()
        }
        return UIMenu(title: "", children: [setPinAction, removePinAction])

    }

    func getTourMenu() -> UIMenu{
        let startTourAction = UIAction(title: "startTour".localize(), image: UIImage(systemName: "figure.walk")) { action in
            self.startTour()
        }
        let stopTourAction = UIAction(title: "stopTour".localize(), image: UIImage(systemName: "figure.stand")) { action in
            self.stopTour()
        }
        return UIMenu(title: "", children: [startTourAction, stopTourAction])

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

    func setPin(){

    }

    func removePin(){

    }

    func startTour(){

    }

    func stopTour(){

    }

    @objc func openCamera(){

    }

    func openSettings(){

    }

    func openExport(){

    }

    private func drawPins(){

    }
    
}

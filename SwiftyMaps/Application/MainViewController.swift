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
    var isShowingPins : Bool = false

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
        mapView.mapType = .standard
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(headerView.bottomAnchor, inset: 1)
                .trailing(guide.trailingAnchor, inset: .zero)
                .bottom(guide.bottomAnchor, inset: .zero)
        applySettings()
    }
    
    func applySettings(){
        mapView.showsUserLocation = Settings.shared.showUserLocation
    }
    
    func updateSettings(){
        Settings.shared.showUserLocation = mapView.showsUserLocation
    }

    // menu

    var styleButton : MenuButton!
    var tourButton : MenuButton!
    var pinButton : MenuButton!
    var cameraButton : MenuButton!
    var configButton : MenuButton!
    var infoButton : MenuButton!

    func fillMenu(menuView: UIView) {
        styleButton = MenuButton(icon: "map", menu: getStyleMenu())
        menuView.addSubview(styleButton)
        tourButton = MenuButton(icon: "figure.walk", menu: getTourMenu(isTracking: isTracking))
        menuView.addSubview(tourButton)
        pinButton = MenuButton(icon: "mappin", menu: getPinMenu(isShowingPins: isShowingPins))
        menuView.addSubview(pinButton)
        cameraButton = MenuButton(icon: "camera", menu: getCameraMenu())
        menuView.addSubview(cameraButton)
        configButton = MenuButton(icon: "slider.horizontal.3", menu: getConfigMenu())
        configButton.showsMenuAsPrimaryAction = true
        menuView.addSubview(configButton)
        infoButton = MenuButton(icon: "info.circle", menu: getInfoMenu())
        menuView.addSubview(infoButton)

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

    func getTourMenu(isTracking: Bool) -> UIMenu {
        let title = isTracking ? "stop" : "start"
        let img = isTracking ? UIImage(systemName: "figure.stand") : UIImage(systemName: "figure.walk")
        let toggleAction = UIAction(title: title.localize(), image: img) { action in
            self.isTracking = !self.isTracking
            self.tourButton.menu = self.getTourMenu(isTracking: !isTracking)
        }
        return UIMenu(title: "", children: [toggleAction])
    }

    func getPinMenu(isShowingPins: Bool) -> UIMenu{
        let title = isShowingPins ? "hidePins" : "showPins"
        let img = isShowingPins ? UIImage(systemName: "mappin.slash") : UIImage(systemName: "mappin")
        let toggleAction = UIAction(title: title.localize(), image: img) { action in
                self.isShowingPins = !self.isShowingPins
                self.pinButton.menu = self.getPinMenu(isShowingPins: !isShowingPins)

        }
        let addAction = UIAction(title: "addPin".localize(), image: UIImage(systemName: "mappin.and.ellipse")) { action in

        }
        return UIMenu(title: "", children: [toggleAction, addAction])
    }

    func getCameraMenu() -> UIMenu{
        let addPhoto = UIAction(title: "addPhoto".localize(), image: UIImage(systemName: "camera")) { action in

        }
        return UIMenu(title: "", children: [addPhoto])
    }

    func getConfigMenu() -> UIMenu{
        let settingsAction = UIAction(title: "settings".localize(), image: UIImage(systemName: "gearshape")) { action in

        }
        let exportAction = UIAction(title: "export".localize(), image: UIImage(systemName: "square.and.arrow.up")) { action in

        }
        return UIMenu(title: "", children: [settingsAction, exportAction])

    }

    func getInfoMenu() -> UIMenu{
        let appAction = UIAction(title: "app".localize()) { action in

        }
        return UIMenu(title: "", children: [appAction])

    }

    private func drawPins(){

    }
}

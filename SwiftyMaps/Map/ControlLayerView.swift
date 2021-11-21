/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol ControlLayerDelegate{
    func preloadMap()
    func deleteTiles()
    func openMapPreferences()
    func focusUserLocation()
    func openGeneralPreferences()
    func openInfo()
    func openCamera()
    func addPlace()
    func openCurrentTrack()
    func openTrackList()
    func openTrackingPreferences()
    
}

class ControlLayerView: UIView {
    
    var delegate : ControlLayerDelegate? = nil
    
    var mapMenuControl = IconButton(icon: "map")
    var zoomIcon = IconButton(icon: "square", tintColor: .gray)
    var toggleCrossControl = IconButton(icon: "mappin.and.ellipse")
    var crossControl = IconButton(icon: "plus.circle")
    var trackMenuControl = IconButton(icon: "figure.walk")
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        let topControlLine = MapControlLine()
        topControlLine.setup()
        addSubview(topControlLine)
        topControlLine.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: Insets.doubleInsets)
        
        topControlLine.addSubview(mapMenuControl)
        mapMenuControl.setAnchors(top: topControlLine.topAnchor, leading: topControlLine.leadingAnchor, bottom: topControlLine.bottomAnchor, insets: Insets.flatInsets)
        mapMenuControl.menu = getMapMenu()
        mapMenuControl.showsMenuAsPrimaryAction = true
        
        let focusUserLocationControl = IconButton(icon: "record.circle")
        topControlLine.addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: topControlLine.topAnchor, bottom: topControlLine.bottomAnchor, insets: Insets.flatInsets)
            .centerX(topControlLine.centerXAnchor)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        let openInfoControl = IconButton(icon: "info.circle")
        topControlLine.addSubview(openInfoControl)
        openInfoControl.setAnchors(top: topControlLine.topAnchor, trailing: topControlLine.trailingAnchor, bottom: topControlLine.bottomAnchor, insets: Insets.flatInsets)
        openInfoControl.addTarget(self, action: #selector(openInfo), for: .touchDown)
        
        let openPreferencesControl = IconButton(icon: "gearshape")
        topControlLine.addSubview(openPreferencesControl)
        openPreferencesControl.setAnchors(top: topControlLine.topAnchor, trailing: openInfoControl.leadingAnchor, bottom: topControlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2*Insets.defaultInset))
        openPreferencesControl.addTarget(self, action: #selector(openGeneralPreferences), for: .touchDown)

        let bottomControlLine = MapControlLine()
        bottomControlLine.setup()
        addSubview(bottomControlLine)
        bottomControlLine.setAnchors(leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*Insets.defaultInset, bottom: 2*Insets.defaultInset, right: 2*Insets.defaultInset))
        
        let openCameraControl = IconButton(icon: "camera")
        bottomControlLine.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: bottomControlLine.topAnchor, leading: bottomControlLine.leadingAnchor, bottom: bottomControlLine.bottomAnchor, insets: Insets.flatInsets)
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        bottomControlLine.addSubview(trackMenuControl)
        trackMenuControl.setAnchors(top: bottomControlLine.topAnchor, trailing: bottomControlLine.trailingAnchor, bottom: bottomControlLine.bottomAnchor, insets: Insets.flatInsets)
        trackMenuControl.menu = getTrackingMenu()
        trackMenuControl.showsMenuAsPrimaryAction = true
        
        bottomControlLine.addSubview(toggleCrossControl)
        toggleCrossControl.setAnchors(top: bottomControlLine.topAnchor, bottom: bottomControlLine.bottomAnchor, insets: Insets.flatInsets)
            .centerX(bottomControlLine.centerXAnchor)
        toggleCrossControl.addTarget(self, action: #selector(toggleCross), for: .touchDown)
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        crossControl.addTarget(self, action: #selector(placeCrossTouched), for: .touchDown)
        crossControl.isHidden = true
        
        addSubview(licenseView)
        licenseView.setAnchors(top: bottomControlLine.bottomAnchor, trailing: layoutGuide.trailingAnchor, insets: UIEdgeInsets(top: Insets.defaultInset, left: Insets.defaultInset, bottom: 0, right: Insets.defaultInset))
        var label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        licenseView.addSubview(label)
        label.setAnchors(top: licenseView.topAnchor, leading: licenseView.leadingAnchor, bottom: licenseView.bottomAnchor)
        label.text = "© "
        let link = UIButton()
        link.setTitleColor(.systemBlue, for: .normal)
        link.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        licenseView.addSubview(link)
        link.setAnchors(top: licenseView.topAnchor, leading: label.trailingAnchor, bottom: licenseView.bottomAnchor)
        link.setTitle("OpenStreetMap", for: .normal)
        link.addTarget(self, action: #selector(openOSMUrl), for: .touchDown)
        label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        licenseView.addSubview(label)
        label.setAnchors(top: licenseView.topAnchor, leading: link.trailingAnchor, trailing: licenseView.trailingAnchor, bottom: licenseView.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Insets.defaultInset))
        label.text = " contributors"
    }
    
    func getMapMenu() -> UIMenu{
        let preloadMapAction = UIAction(title: "preloadMaps".localize(), image: UIImage(systemName: "square.and.arrow.down")){ action in
            self.delegate?.preloadMap()
        }
        let deleteTilesAction = UIAction(title: "deleteTiles".localize(), image: UIImage(systemName: "trash")){ action in
            self.delegate?.deleteTiles()
        }
        let mapConfigAction = UIAction(title: "configureMap".localize(), image: UIImage(systemName: "gearshape")){ action in
            self.delegate?.openMapPreferences()
        }
        return UIMenu(title: "", children: [preloadMapAction, deleteTilesAction, mapConfigAction])
    }
    
    func getTrackingMenu() -> UIMenu{
        var trackingAction : UIAction!
        if TrackController.isTracking{
            trackingAction = UIAction(title: "stopTracking".localize(), image: UIImage(systemName: "figure.stand")){ action in
                TrackController.isTracking = false
                self.trackMenuControl.menu = self.getTrackingMenu()
                self.trackMenuControl.setImage(UIImage(systemName: "figure.walk"), for: .normal)
            }
        }
        else{
            trackingAction = UIAction(title: "startTracking".localize(), image: UIImage(systemName: "figure.walk")){ action in
                TrackController.isTracking = true
                self.trackMenuControl.menu = self.getTrackingMenu()
                self.trackMenuControl.setImage(UIImage(systemName: "figure.stand"), for: .normal)
            }
        }
        let currentTrackAction = UIAction(title: "showCurrentTrack".localize(), image: UIImage(systemName: "magifyingglass")){ action in
            self.delegate?.openCurrentTrack()
        }
        let trackListAction = UIAction(title: "showTrackList".localize(), image: UIImage(systemName: "list.bullet")){ action in
            self.delegate?.openTrackList()
        }
        let trackPreferencesAction = UIAction(title: "configureTracks".localize(), image: UIImage(systemName: "gearshape")){ action in
            self.delegate?.openTrackingPreferences()
        }
        return UIMenu(title: "", children: [trackingAction, currentTrackAction, trackListAction, trackPreferencesAction])
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 is MapControlLine || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func toggleCross(){
        if crossControl.isHidden{
            crossControl.isHidden = false
            toggleCrossControl.setImage(UIImage(systemName: "circle.slash"), for: .normal)
        }
        else{
            crossControl.isHidden = true
            toggleCrossControl.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        }
    }
    
    @objc func openInfo(){
        delegate?.openInfo()
    }
    
    @objc func openCamera(){
        delegate?.openCamera()
    }
    
    @objc func placeCrossTouched(){
        delegate?.addPlace()
    }
    
    @objc func openGeneralPreferences(){
        delegate?.openGeneralPreferences()
    }
    
}

class MapControlLine : UIView{
    
    func setup(){
        backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}





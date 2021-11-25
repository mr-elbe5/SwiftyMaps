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
    func openPlaceList()
    func showPlaces(_ show: Bool)
    func deletePlaces()
    func focusUserLocation()
    func openInfo()
    func openCamera()
    func addPlace()
    func openCurrentTrack()
    func openTrackList()
    func deleteTracks()
    func openTrackingPreferences()
    
}

class ControlLayerView: UIView {
    
    var delegate : ControlLayerDelegate? = nil
    
    var controlLine = UIView()
    var mapMenuControl = IconButton(icon: "map")
    var placeMenuControl = IconButton(icon: "mappin.and.ellipse")
    var trackMenuControl = IconButton(icon: "figure.walk")
    var zoomIcon = IconButton(icon: "square", tintColor: .gray)
    var crossControl = IconButton(icon: "plus.circle")
    var trackInfoLine = TrackInfoLine()
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        controlLine.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        controlLine.layer.cornerRadius = 10
        controlLine.layer.masksToBounds = true
        addSubview(controlLine)
        controlLine.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: Insets.doubleInsets)
        
        controlLine.addSubview(mapMenuControl)
        mapMenuControl.setAnchors(top: controlLine.topAnchor, leading: controlLine.leadingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0))
        mapMenuControl.menu = getMapMenu()
        mapMenuControl.showsMenuAsPrimaryAction = true
        
        controlLine.addSubview(placeMenuControl)
        placeMenuControl.setAnchors(top: controlLine.topAnchor, leading: mapMenuControl.trailingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        placeMenuControl.menu = getPlaceMenu()
        placeMenuControl.showsMenuAsPrimaryAction = true
        
        controlLine.addSubview(trackMenuControl)
        trackMenuControl.setAnchors(top: controlLine.topAnchor, leading: placeMenuControl.trailingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        trackMenuControl.menu = getTrackingMenu()
        trackMenuControl.showsMenuAsPrimaryAction = true
        
        let focusUserLocationControl = IconButton(icon: "record.circle")
        controlLine.addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: controlLine.topAnchor, bottom: controlLine.bottomAnchor)
            .centerX(controlLine.centerXAnchor)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        let infoControl = IconButton(icon: "info.circle")
        controlLine.addSubview(infoControl)
        infoControl.setAnchors(top: controlLine.topAnchor, trailing: controlLine.trailingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 10))
        infoControl.addTarget(self, action: #selector(openInfo), for: .touchDown)
        
        let openCameraControl = IconButton(icon: "camera")
        controlLine.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: controlLine.topAnchor, trailing: infoControl.leadingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 30))
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        trackInfoLine.setup()
        addSubview(trackInfoLine)
        trackInfoLine.setAnchors(leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*Insets.defaultInset, bottom: 2*Insets.defaultInset, right: 2*Insets.defaultInset))
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        crossControl.addTarget(self, action: #selector(placeCrossTouched), for: .touchDown)
        crossControl.isHidden = true
        
        addSubview(licenseView)
        licenseView.setAnchors(top: trackInfoLine.bottomAnchor, trailing: layoutGuide.trailingAnchor, insets: UIEdgeInsets(top: Insets.defaultInset, left: Insets.defaultInset, bottom: 0, right: Insets.defaultInset))
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
        let deleteTilesAction = UIAction(title: "deleteTiles".localize(), image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deleteTiles()
        }
        let mapConfigAction = UIAction(title: "configureMap".localize(), image: UIImage(systemName: "gearshape")){ action in
            self.delegate?.openMapPreferences()
        }
        return UIMenu(title: "", children: [preloadMapAction, deleteTilesAction, mapConfigAction])
    }
    
    func getPlaceMenu() -> UIMenu{
        let addPlaceAction = UIAction(title: "addPlace".localize(), image: UIImage(systemName: "plus.circle")){ action in
            self.activateCross()
        }
        var showPlacesAction : UIAction!
        if MapPreferences.instance.showPlaceMarkers{
            showPlacesAction = UIAction(title: "hidePlaces".localize(), image: UIImage(systemName: "mappin.slash")){ action in
                self.delegate?.showPlaces(false)
                self.placeMenuControl.menu = self.getPlaceMenu()
            }
        }
        else{
            showPlacesAction = UIAction(title: "showPlaces".localize(), image: UIImage(systemName: "mappin")){ action in
                self.delegate?.showPlaces(true)
                self.placeMenuControl.menu = self.getPlaceMenu()
                
            }
        }
        let showPlaceListAction = UIAction(title: "showPlaceList".localize(), image: UIImage(systemName: "list.bullet")){ action in
            self.delegate?.openPlaceList()
        }
        let deletePlacesAction = UIAction(title: "deletePlaces".localize(), image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deletePlaces()
        }
        return UIMenu(title: "", children: [addPlaceAction, showPlaceListAction, showPlacesAction, deletePlacesAction])
    }
    
    func getTrackingMenu() -> UIMenu{
        var trackingAction : UIAction!
        if Tracks.instance.isTracking{
            trackingAction = UIAction(title: "showCurrentTrack".localize(), image: UIImage(systemName: "figure.walk")){ action in
                self.delegate?.openCurrentTrack()
                self.trackMenuControl.menu = self.getTrackingMenu()
            }
        }
        else{
            trackingAction = UIAction(title: "startNewTrack".localize(), image: UIImage(systemName: "figure.walk")){ action in
                Tracks.instance.startTracking()
                self.trackMenuControl.menu = self.getTrackingMenu()
                self.startTrackInfo()
            }
        }
        let trackListAction = UIAction(title: "showTrackList".localize(), image: UIImage(systemName: "list.bullet")){ action in
            self.delegate?.openTrackList()
        }
        let deleteTracksAction = UIAction(title: "deleteTracks".localize(), image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deleteTracks()
        }
        let trackPreferencesAction = UIAction(title: "configureTracks".localize(), image: UIImage(systemName: "gearshape")){ action in
            self.delegate?.openTrackingPreferences()
        }
        return UIMenu(title: "", children: [trackingAction, trackListAction, deleteTracksAction, trackPreferencesAction])
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 == controlLine || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func openInfo(){
        delegate?.openInfo()
    }
    
    @objc func openCamera(){
        delegate?.openCamera()
    }
    
    @objc func placeCrossTouched(){
        delegate?.addPlace()
        crossControl.isHidden = true
    }
    
    func activateCross(){
        crossControl.isHidden = false
    }
    
    func startTrackInfo(){
        trackInfoLine.startInfo()
    }
    
    func updateTrackInfo(){
        trackInfoLine.updateInfo()
    }
    
    func stopTrackInfo(){
        trackInfoLine.stopInfo()
    }
    
}

class MapControlLine : UIView{
    
    func setup(){
        backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}






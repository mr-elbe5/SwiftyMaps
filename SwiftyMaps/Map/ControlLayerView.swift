/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol ControlLayerDelegate{
    func preloadMap()
    func deleteTiles()
    func showLocations(_ show: Bool)
    func focusUserLocation()
    func openCamera()
    func addLocation()
    func startTracking()
    func openTrack(track: TrackData)
    func hideTrack()
}

class ControlLayerView: UIView {
    
    //MainViewController
    var delegate : ControlLayerDelegate? = nil
    
    var controlLine = UIView()
    var mapMenuControl = IconButton(icon: "map")
    var locationMenuControl = IconButton(icon: "mappin")
    var trackMenuControl = IconButton(icon: "figure.walk")
    var crossControl = IconButton(icon: "plus.circle")
    var currentTrackLine = CurrentTrackLine()
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        controlLine.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        controlLine.layer.cornerRadius = 10
        controlLine.layer.masksToBounds = true
        addSubview(controlLine)
        controlLine.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: doubleInsets)
        
        controlLine.addSubview(mapMenuControl)
        mapMenuControl.setAnchors(top: controlLine.topAnchor, leading: controlLine.leadingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0))
        mapMenuControl.menu = getMapMenu()
        mapMenuControl.showsMenuAsPrimaryAction = true
        
        controlLine.addSubview(locationMenuControl)
        locationMenuControl.setAnchors(top: controlLine.topAnchor, leading: mapMenuControl.trailingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        locationMenuControl.menu = getLocationMenu()
        locationMenuControl.showsMenuAsPrimaryAction = true
        
        controlLine.addSubview(trackMenuControl)
        trackMenuControl.setAnchors(top: controlLine.topAnchor, leading: locationMenuControl.trailingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        trackMenuControl.menu = getTrackingMenu()
        trackMenuControl.showsMenuAsPrimaryAction = true
        
        let focusUserLocationControl = IconButton(icon: "record.circle")
        controlLine.addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: controlLine.topAnchor, bottom: controlLine.bottomAnchor)
            .centerX(controlLine.centerXAnchor)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        let openCameraControl = IconButton(icon: "camera")
        controlLine.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: controlLine.topAnchor, trailing: controlLine.trailingAnchor, bottom: controlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 30))
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        currentTrackLine.setup()
        addSubview(currentTrackLine)
        currentTrackLine.setAnchors(leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*defaultInset, bottom: 2*defaultInset, right: 2*defaultInset))
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        crossControl.addTarget(self, action: #selector(locationCrossTouched), for: .touchDown)
        crossControl.isHidden = true
        
        addSubview(licenseView)
        licenseView.setAnchors(top: currentTrackLine.bottomAnchor, trailing: layoutGuide.trailingAnchor, insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: 0, right: defaultInset))
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
        label.setAnchors(top: licenseView.topAnchor, leading: link.trailingAnchor, trailing: licenseView.trailingAnchor, bottom: licenseView.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: defaultInset))
        label.text = " contributors"
    }
    
    func getMapMenu() -> UIMenu{
        let preloadMapAction = UIAction(title: "preloadMaps".localize(), image: UIImage(systemName: "square.and.arrow.down")){ action in
            self.delegate?.preloadMap()
        }
        let deleteTilesAction = UIAction(title: "deleteTiles".localize(), image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deleteTiles()
        }
        return UIMenu(title: "", children: [preloadMapAction, deleteTilesAction])
    }
    
    func getLocationMenu() -> UIMenu{
        let addLocationAction = UIAction(title: "addLocation".localize(), image: UIImage(systemName: "plus.circle")){ action in
            self.activateCross()
        }
        var showLocationsAction : UIAction!
        if Preferences.instance.showPins{
            showLocationsAction = UIAction(title: "hideLocations".localize(), image: UIImage(systemName: "mappin.slash")){ action in
                self.delegate?.showLocations(false)
                self.locationMenuControl.menu = self.getLocationMenu()
            }
        }
        else{
            showLocationsAction = UIAction(title: "showLocations".localize(), image: UIImage(systemName: "mappin")){ action in
                self.delegate?.showLocations(true)
                self.locationMenuControl.menu = self.getLocationMenu()
                
            }
        }
        return UIMenu(title: "", children: [addLocationAction, showLocationsAction])
    }
    
    func getTrackingMenu() -> UIMenu{
        let hideTrackAction = UIAction(title: "hideTrack".localize(), image: UIImage(systemName: "eye.slash")){ action in
            self.delegate?.hideTrack()
        }
        if let track = ActiveTrack.track{
            let showCurrentAction = UIAction(title: "showCurrentTrack".localize(), image: UIImage(systemName: "figure.walk")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)){ action in
                self.delegate?.openTrack(track: track)
                self.trackMenuControl.menu = self.getTrackingMenu()
            }
            return UIMenu(title: "", children: [showCurrentAction, hideTrackAction])
        }
        else{
            let startTrackAction = UIAction(title: "startNewTrack".localize(), image: UIImage(systemName: "figure.walk")){ action in
                self.delegate?.startTracking()
                self.trackMenuControl.menu = self.getTrackingMenu()
            }
            return UIMenu(title: "", children: [startTrackAction, hideTrackAction])
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 == controlLine || $0 == currentTrackLine || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func openCamera(){
        delegate?.openCamera()
    }
    
    @objc func locationCrossTouched(){
        delegate?.addLocation()
        crossControl.isHidden = true
    }
    
    func activateCross(){
        crossControl.isHidden = false
    }
    
    func startTrackInfo(){
        currentTrackLine.startInfo()
        currentTrackLine.updatePauseResumeButton()
    }
    
    func pauseTrackInfo(){
        currentTrackLine.updatePauseResumeButton()
    }
    
    func resumeTrackInfo(){
        currentTrackLine.updatePauseResumeButton()
    }
    
    func updateTrackInfo(){
        currentTrackLine.updateInfo()
    }
    
    func stopTrackInfo(){
        currentTrackLine.stopInfo()
    }
    
    func startTrackControl(){
        trackMenuControl.menu = getTrackingMenu()
        startTrackInfo()
    }
    
    func stopTrackControl(){
        trackMenuControl.menu = getTrackingMenu()
        stopTrackInfo()
    }
    
}

class MapControlLine : UIView{
    
    func setup(){
        backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}






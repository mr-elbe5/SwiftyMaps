/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

//MapViewController
protocol ControlLayerDelegate{
    func preloadMap()
    func deleteTiles()
    func addLocation()
    func focusUserLocation()
    func updatePinVisibility()
    func updateTrackVisibility()
    func openCamera()
    func updateTrackLayer()
    func saveAndCloseTracking()
}

class ControlLayerView: UIView {
    
    static let layerBackground : UIColor = .white
    
    //MapViewController
    var delegate : ControlLayerDelegate? = nil
    
    var statusInfo = UIView()
    var heightLabel = UILabel()
    var headingLabel = UILabel()
    
    var trackingInfo = UIView()
    var distanceLabel = UILabel()
    var distanceUpLabel = UILabel()
    var distanceDownLabel = UILabel()
    var timeLabel = UILabel()
    var timer : Timer? = nil
    var bearingLabel = UILabel()
    var speedLabel = UILabel()
    
    var menuControl = UIView()
    var mapMenuControl = IconButton(icon: "map")
    var locationMenuControl = IconButton(icon: "mappin")
    var trackingMenuControl = IconButton(icon: "figure.walk")
    var focusUserLocationControl = IconButton(icon: "record.circle")
    var openCameraControl = IconButton(icon: "camera")
    
    var licenseView = UIView()
    
    var iconInsets = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 1)
    var labelInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 5)
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        statusInfo.backgroundColor = ControlLayerView.layerBackground
        statusInfo.layer.cornerRadius = 10
        statusInfo.layer.masksToBounds = true
        addSubview(statusInfo)
        statusInfo.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: defaultInsets)
        setupStatusInfo()
        
        menuControl.backgroundColor = ControlLayerView.layerBackground
        menuControl.layer.cornerRadius = 10
        menuControl.layer.masksToBounds = true
        addSubview(menuControl)
        menuControl.setAnchors(top: statusInfo.bottomAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: defaultInsets)
        setupMenuControl()
        
        addSubview(licenseView)
        licenseView.setAnchors(trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: 0, right: defaultInset))
        fillLicenseView()
        
        trackingInfo.backgroundColor = ControlLayerView.layerBackground
        trackingInfo.layer.cornerRadius = 10
        trackingInfo.layer.masksToBounds = true
        addSubview(trackingInfo)
        trackingInfo.setAnchors(leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: licenseView.topAnchor, insets: flatInsets)
        setupTrackingInfo()
        trackingInfo.isHidden = true
    }
    
    func setupStatusInfo(){
        
        let headingIcon = UIImageView(image: UIImage(systemName: "safari"))
        headingIcon.tintColor = .darkGray
        statusInfo.addSubview(headingIcon)
        headingIcon.setAnchors(top: statusInfo.topAnchor, leading: statusInfo.leadingAnchor, bottom: statusInfo.bottomAnchor, insets: iconInsets)
        headingLabel.textColor = .darkGray
        headingLabel.text = "0°"
        statusInfo.addSubview(headingLabel)
        headingLabel.setAnchors(top: statusInfo.topAnchor, leading: headingIcon.trailingAnchor, bottom: statusInfo.bottomAnchor, insets: labelInsets)
        
        let heightIcon = UIImageView(image: UIImage(systemName: "triangle.bottomhalf.filled"))
        heightIcon.tintColor = .darkGray
        statusInfo.addSubview(heightIcon)
        heightIcon.setAnchors(top: statusInfo.topAnchor, leading: headingLabel.trailingAnchor, bottom: statusInfo.bottomAnchor, insets: iconInsets)
        heightLabel.textColor = .darkGray
        heightLabel.text = "0m"
        statusInfo.addSubview(heightLabel)
        heightLabel.setAnchors(top: statusInfo.topAnchor, leading: heightIcon.trailingAnchor, bottom: statusInfo.bottomAnchor, insets: labelInsets)
        
    }
    
    func setupTrackingInfo(){
        let distanceIcon = UIImageView(image: UIImage(systemName: "arrow.right"))
        distanceIcon.tintColor = .darkGray
        trackingInfo.addSubview(distanceIcon)
        distanceIcon.setAnchors(top: trackingInfo.topAnchor, leading: trackingInfo.leadingAnchor, bottom: trackingInfo.bottomAnchor, insets: iconInsets)
        distanceLabel.textColor = .darkGray
        trackingInfo.addSubview(distanceLabel)
        distanceLabel.setAnchors(top: trackingInfo.topAnchor, leading: distanceIcon.trailingAnchor, bottom: trackingInfo.bottomAnchor,insets: labelInsets)
        
        let distanceUpIcon = UIImageView(image: UIImage(systemName: "arrow.up"))
        distanceUpIcon.tintColor = .darkGray
        trackingInfo.addSubview(distanceUpIcon)
        distanceUpIcon.setAnchors(top: trackingInfo.topAnchor, leading: distanceLabel.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: iconInsets)
        distanceUpLabel.textColor = .darkGray
        trackingInfo.addSubview(distanceUpLabel)
        distanceUpLabel.setAnchors(top: trackingInfo.topAnchor, leading: distanceUpIcon.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: labelInsets)
        
        let distanceDownIcon = UIImageView(image: UIImage(systemName: "arrow.down"))
        distanceDownIcon.tintColor = .darkGray
        trackingInfo.addSubview(distanceDownIcon)
        distanceDownIcon.setAnchors(top: trackingInfo.topAnchor, leading: distanceUpLabel.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: iconInsets)
        distanceDownLabel.textColor = .darkGray
        trackingInfo.addSubview(distanceDownLabel)
        distanceDownLabel.setAnchors(top: trackingInfo.topAnchor, leading: distanceDownIcon.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: labelInsets)
        
        let timeIcon = UIImageView(image: UIImage(systemName: "stopwatch"))
        timeIcon.tintColor = .darkGray
        trackingInfo.addSubview(timeIcon)
        timeIcon.setAnchors(top: trackingInfo.topAnchor, leading: distanceDownLabel.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: iconInsets)
        timeLabel.textColor = .darkGray
        trackingInfo.addSubview(timeLabel)
        timeLabel.setAnchors(top: trackingInfo.topAnchor, leading: timeIcon.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: labelInsets)
        
        let speedIcon = UIImageView(image: UIImage(systemName: "figure.walk"))
        speedIcon.tintColor = .darkGray
        trackingInfo.addSubview(speedIcon)
        speedIcon.setAnchors(top: trackingInfo.topAnchor, leading: timeLabel.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: iconInsets)
        speedLabel.textColor = .darkGray
        trackingInfo.addSubview(speedLabel)
        speedLabel.setAnchors(top: trackingInfo.topAnchor, leading: speedIcon.trailingAnchor, bottom: trackingInfo.bottomAnchor, insets: labelInsets)
        resetTrackInfo()
    }
    
    func setupMenuControl(){
        menuControl.removeAllSubviews()
        menuControl.addSubview(mapMenuControl)
        mapMenuControl.setAnchors(top: menuControl.topAnchor, leading: menuControl.leadingAnchor, bottom: menuControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0))
        mapMenuControl.menu = getMapMenu()
        mapMenuControl.showsMenuAsPrimaryAction = true
        
        menuControl.addSubview(locationMenuControl)
        locationMenuControl.setAnchors(top: menuControl.topAnchor, leading: mapMenuControl.trailingAnchor, bottom: menuControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        locationMenuControl.menu = getLocationMenu()
        locationMenuControl.showsMenuAsPrimaryAction = true
        
        menuControl.addSubview(trackingMenuControl)
        trackingMenuControl.setAnchors(top: menuControl.topAnchor, leading: locationMenuControl.trailingAnchor, bottom: menuControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        trackingMenuControl.menu = getTrackingMenu()
        trackingMenuControl.showsMenuAsPrimaryAction = true
        
        menuControl.addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: menuControl.topAnchor, bottom: menuControl.bottomAnchor)
            .centerX(menuControl.centerXAnchor)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        menuControl.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: menuControl.topAnchor, trailing: menuControl.trailingAnchor, bottom: menuControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 30))
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
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
        var actions = Array<UIAction>()
        if Preferences.instance.showPins{
            actions.append(UIAction(title: "hideLocations".localize(), image: UIImage(systemName: "eye.slash")){ action in
                Preferences.instance.showPins = false
                Preferences.instance.save()
                self.delegate?.updatePinVisibility()
                self.locationMenuControl.menu = self.getLocationMenu()
            })
        }
        else{
            actions.append(UIAction(title: "showLocations".localize(), image: UIImage(systemName: "eye")){ action in
                Preferences.instance.showPins = true
                Preferences.instance.save()
                self.delegate?.updatePinVisibility()
                self.locationMenuControl.menu = self.getLocationMenu()
            })
        }
        actions.append(UIAction(title: "addLocation".localize(), image: UIImage(systemName: "mappin")){ action in
            self.delegate?.addLocation()
        })
        return UIMenu(title: "", children: actions)
    }
    
    func updateLocationMenu(){
        locationMenuControl.menu = self.getLocationMenu()
    }
    
    func getTrackingMenu() -> UIMenu{
        var actions = Array<UIAction>()
        if TrackPool.isTracking{
            if TrackPool.isPausing{
                actions.append(UIAction(title: "resume".localize(), image: UIImage(systemName: "figure.walk.motion")){ action in
                    TrackPool.resumeTracking()
                    self.startTimer()
                    self.updateTrackingMenu()
                })
            }
            else{
                actions.append(UIAction(title: "pause".localize(), image: UIImage(systemName: "figure.stand")){ action in
                    TrackPool.pauseTracking()
                    self.stopTimer()
                    self.updateTrackingMenu()
                })
            }
            actions.append(UIAction(title: "cancel".localize(), image: UIImage(systemName: "trash")){ action in
                TrackPool.cancelTracking()
                self.stopTimer()
                self.updateTrackingMenu()
                self.delegate?.updateTrackLayer()
                self.resetTrackInfo()
                self.trackingInfo.isHidden = true
            })
            actions.append(UIAction(title: "stopTracking".localize(), image: UIImage(systemName: "stop.circle")){ action in
                self.delegate?.saveAndCloseTracking()
            })
        }
        else{
            actions.append(UIAction(title: "startTracking".localize(), image: UIImage(systemName: "figure.walk.departure")){ action in
                TrackPool.startTracking()
                Preferences.instance.showTrack = true
                self.startTimer()
                self.delegate?.updateTrackVisibility()
                self.trackingInfo.isHidden = false
                self.updateTrackingMenu()
                self.setupStatusInfo()
            })
            if Preferences.instance.showTrack{
                actions.append(UIAction(title: "hide".localize(), image: UIImage(systemName: "eye.slash")){ action in
                    Preferences.instance.showTrack = false
                    Preferences.instance.save()
                    self.delegate?.updateTrackVisibility()
                    self.updateTrackingMenu()
                })
            }
            else{
                actions.append(UIAction(title: "show".localize(), image: UIImage(systemName: "eye")){ action in
                    Preferences.instance.showTrack = true
                    Preferences.instance.save()
                    self.delegate?.updateTrackVisibility()
                    self.updateTrackingMenu()
                })
            }
        }
        return UIMenu(title: "", children: actions)
    }
    
    func trackingStopped(){
        stopTimer()
        self.resetTrackInfo()
        trackingInfo.isHidden = false
    }
    
    func updateTrackingMenu(){
        trackingMenuControl.menu = self.getTrackingMenu()
    }
    
    func fillLicenseView(){
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 == menuControl || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    // status
    
    func updateTrackInfo(){
        if let track = TrackPool.activeTrack{
            distanceLabel.text = "\(Int(track.distance))m"
            distanceUpLabel.text = "\(Int(track.upDistance))m"
            distanceDownLabel.text = "\(Int(track.downDistance))m"
        }
    }
    
    func resetTrackInfo(){
        distanceLabel.text = "0m"
        distanceUpLabel.text = "0m"
        distanceDownLabel.text = "0m"
        timeLabel.text = 0.hmsString()
        speedLabel.text = "0km/h"
        bearingLabel.text = "0°"
    }
    
    func updateLocationInfo(position: Position){
        heightLabel.text = "\(Int(position.altitude))m"
        bearingLabel.text = "\(position.bearing)°"
        speedLabel.text = "\(String(format: "%.1f", position.speed))km/h"
    }
    
    func updateHeadingInfo(heading: Int){
        headingLabel.text = "\(heading)°"
    }
    
    // top
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func openCamera(){
        delegate?.openCamera()
    }
    
    // license
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
    
    // timer
    
    func startTimer(){
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTime(){
        if let track = TrackPool.activeTrack{
            timeLabel.text = track.durationUntilNow.hmsString()
        }
    }
    
}





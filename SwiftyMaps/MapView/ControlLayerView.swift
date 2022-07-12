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
    
    //MapViewController
    var delegate : ControlLayerDelegate? = nil
    
    var statusControl = UIView()
    var distanceLabel = UILabel()
    var distanceUpLabel = UILabel()
    var distanceDownLabel = UILabel()
    var timeLabel = UILabel()
    var timer : Timer? = nil
    var heightLabel = UILabel()
    
    var topControl = UIView()
    var mapMenuControl = IconButton(icon: "map")
    var locationMenuControl = IconButton(icon: "mappin")
    var trackingMenuControl = IconButton(icon: "figure.walk")
    var focusUserLocationControl = IconButton(icon: "record.circle")
    var openCameraControl = IconButton(icon: "camera")
    
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        statusControl.backgroundColor = .white //UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        addSubview(statusControl)
        statusControl.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: .zero)
        updateStatusControl()
        
        topControl.backgroundColor = .white //UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        topControl.layer.cornerRadius = 10
        topControl.layer.masksToBounds = true
        addSubview(topControl)
        topControl.setAnchors(top: statusControl.bottomAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: defaultInsets)
        updateTopControl()
        
        addSubview(licenseView)
        licenseView.setAnchors(trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: 0, right: defaultInset))
        fillLicenseView()
    }
    
    func updateStatusControl(){
        statusControl.removeAllSubviews()
        if TrackPool.isTracking{
            let distanceIcon = UIImageView(image: UIImage(systemName: "arrow.right"))
            distanceIcon.tintColor = .darkGray
            statusControl.addSubview(distanceIcon)
            distanceIcon.setAnchors(top: statusControl.topAnchor, leading: statusControl.leadingAnchor, bottom: statusControl.bottomAnchor, insets: flatInsets)
            distanceLabel.textColor = .darkGray
            distanceLabel.text = "0m"
            statusControl.addSubview(distanceLabel)
            distanceLabel.setAnchors(top: statusControl.topAnchor, leading: distanceIcon.trailingAnchor, bottom: statusControl.bottomAnchor)
            
            let distanceUpIcon = UIImageView(image: UIImage(systemName: "arrow.up"))
            distanceUpIcon.tintColor = .darkGray
            statusControl.addSubview(distanceUpIcon)
            distanceUpIcon.setAnchors(top: statusControl.topAnchor, leading: distanceLabel.trailingAnchor, bottom: statusControl.bottomAnchor, insets: flatInsets)
            distanceUpLabel.textColor = .darkGray
            distanceUpLabel.text = "0m"
            statusControl.addSubview(distanceUpLabel)
            distanceUpLabel.setAnchors(top: statusControl.topAnchor, leading: distanceUpIcon.trailingAnchor, bottom: statusControl.bottomAnchor)
            
            let distanceDownIcon = UIImageView(image: UIImage(systemName: "arrow.down"))
            distanceDownIcon.tintColor = .darkGray
            statusControl.addSubview(distanceDownIcon)
            distanceDownIcon.setAnchors(top: statusControl.topAnchor, leading: distanceUpLabel.trailingAnchor, bottom: statusControl.bottomAnchor, insets: flatInsets)
            distanceDownLabel.textColor = .darkGray
            distanceDownLabel.text = "0m"
            statusControl.addSubview(distanceDownLabel)
            distanceDownLabel.setAnchors(top: statusControl.topAnchor, leading: distanceDownIcon.trailingAnchor, bottom: statusControl.bottomAnchor)
            
            let timeIcon = UIImageView(image: UIImage(systemName: "stopwatch"))
            timeIcon.tintColor = .darkGray
            statusControl.addSubview(timeIcon)
            timeIcon.setAnchors(top: statusControl.topAnchor, leading: distanceDownLabel.trailingAnchor, bottom: statusControl.bottomAnchor, insets: flatInsets)
            timeLabel.textColor = .darkGray
            statusControl.addSubview(timeLabel)
            timeLabel.setAnchors(top: statusControl.topAnchor, leading: timeIcon.trailingAnchor, bottom: statusControl.bottomAnchor)
        }
        
        heightLabel.textColor = .darkGray
        heightLabel.text = "0m"
        statusControl.addSubview(heightLabel)
        heightLabel.setAnchors(top: statusControl.topAnchor, trailing: statusControl.trailingAnchor, bottom: statusControl.bottomAnchor, insets: flatInsets)
        let heightIcon = UIImageView(image: UIImage(systemName: "triangle.bottomhalf.filled"))
        heightIcon.tintColor = .darkGray
        statusControl.addSubview(heightIcon)
        heightIcon.setAnchors(top: statusControl.topAnchor, trailing: heightLabel.leadingAnchor, bottom: statusControl.bottomAnchor, insets: .zero)
    }
    
    func updateTopControl(){
        topControl.removeAllSubviews()
        topControl.addSubview(mapMenuControl)
        mapMenuControl.setAnchors(top: topControl.topAnchor, leading: topControl.leadingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0))
        mapMenuControl.menu = getMapMenu()
        mapMenuControl.showsMenuAsPrimaryAction = true
        
        topControl.addSubview(locationMenuControl)
        locationMenuControl.setAnchors(top: topControl.topAnchor, leading: mapMenuControl.trailingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        locationMenuControl.menu = getLocationMenu()
        locationMenuControl.showsMenuAsPrimaryAction = true
        
        topControl.addSubview(trackingMenuControl)
        trackingMenuControl.setAnchors(top: topControl.topAnchor, leading: locationMenuControl.trailingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        trackingMenuControl.menu = getTrackingMenu()
        trackingMenuControl.showsMenuAsPrimaryAction = true
        
        topControl.addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: topControl.topAnchor, bottom: topControl.bottomAnchor)
            .centerX(topControl.centerXAnchor)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        topControl.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: topControl.topAnchor, trailing: topControl.trailingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 30))
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
                self.updateStatusControl()
            })
            actions.append(UIAction(title: "stop".localize(), image: UIImage(systemName: "stop.circle")){ action in
                self.delegate?.saveAndCloseTracking()
            })
        }
        else{
            actions.append(UIAction(title: "startTracking".localize(), image: UIImage(systemName: "figure.walk.departure")){ action in
                TrackPool.startTracking()
                Preferences.instance.showTrack = true
                self.startTimer()
                self.delegate?.updateTrackVisibility()
                self.updateTrackingMenu()
                self.updateStatusControl()
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
        self.updateStatusControl()
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
            ($0 == topControl || $0 == statusControl || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
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
    
    func updateLocationInfo(position: Position){
        heightLabel.text = "\(Int(position.altitude))m"
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





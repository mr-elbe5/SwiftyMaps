/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol ControlLayerDelegate{
    func preloadMap()
    func deleteTiles()
    func addLocation()
    func focusUserLocation()
    func updatePinVisibility()
    func openCamera()
    func startTracking()
    func openTrack(track: TrackData)
    func hideTrack()
}

class ControlLayerView: UIView {
    
    //MapViewController
    var delegate : ControlLayerDelegate? = nil
    
    var topControl = UIView()
    var mapMenuControl = IconButton(icon: "map")
    var togglePinsControl = IconButton(icon: "mappin")
    var toggleTrackControl = IconButton(icon: "figure.walk")
    var focusUserLocationControl = IconButton(icon: "record.circle")
    var toggleCrossControl = IconButton(icon: "plus.circle")
    var openCameraControl = IconButton(icon: "camera")
    var crossControl = IconButton(icon: "plus.circle")
    
    var trackControl = UIView()
    var distanceLabel = UILabel()
    var distanceUpLabel = UILabel()
    var distanceDownLabel = UILabel()
    var timeLabel = UILabel()
    var pauseResumeButton = UIButton()
    var timer : Timer? = nil
    
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        topControl.backgroundColor = .white //UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        topControl.layer.cornerRadius = 10
        topControl.layer.masksToBounds = true
        addSubview(topControl)
        topControl.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: doubleInsets)
        fillTopControl()
        
        addSubview(trackControl)
        trackControl.setAnchors(leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*defaultInset, bottom: 2*defaultInset, right: 2*defaultInset))
        fillTrackControl()
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        crossControl.menu = getCrossMenu()
        crossControl.showsMenuAsPrimaryAction = true
        crossControl.isHidden = true
        
        addSubview(licenseView)
        licenseView.setAnchors(top: trackControl.bottomAnchor, trailing: layoutGuide.trailingAnchor, insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: 0, right: defaultInset))
        fillLicenseView()
    }
    
    func fillTopControl(){
        topControl.addSubview(mapMenuControl)
        mapMenuControl.setAnchors(top: topControl.topAnchor, leading: topControl.leadingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0))
        mapMenuControl.menu = getMapMenu()
        mapMenuControl.showsMenuAsPrimaryAction = true
        
        topControl.addSubview(togglePinsControl)
        togglePinsControl.setAnchors(top: topControl.topAnchor, leading: mapMenuControl.trailingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        togglePinsControl.addTarget(self, action: #selector(togglePins), for: .touchDown)
        
        topControl.addSubview(toggleTrackControl)
        toggleTrackControl.setAnchors(top: topControl.topAnchor, leading: togglePinsControl.trailingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 30 , bottom: 0, right: 0))
        toggleTrackControl.addTarget(self, action: #selector(toggleTracking), for: .touchDown)
        
        topControl.addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: topControl.topAnchor, bottom: topControl.bottomAnchor)
            .centerX(topControl.centerXAnchor)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        topControl.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: topControl.topAnchor, trailing: topControl.trailingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 30))
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        topControl.addSubview(toggleCrossControl)
        toggleCrossControl.setAnchors(top: topControl.topAnchor, trailing: openCameraControl.leadingAnchor, bottom: topControl.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 30))
        toggleCrossControl.addTarget(self, action: #selector(toggleCross), for: .touchDown)
    }
    
    func fillTrackControl(){
        trackControl.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        trackControl.layer.cornerRadius = 10
        trackControl.layer.masksToBounds = true
        
        let distanceIcon = UIImageView(image: UIImage(systemName: "arrow.right"))
        distanceIcon.tintColor = .darkGray
        trackControl.addSubview(distanceIcon)
        distanceIcon.setAnchors(top: trackControl.topAnchor, leading: trackControl.leadingAnchor, bottom: trackControl.bottomAnchor, insets: flatInsets)
        distanceLabel.textColor = .darkGray
        distanceLabel.text = "0m"
        trackControl.addSubview(distanceLabel)
        distanceLabel.setAnchors(top: trackControl.topAnchor, leading: distanceIcon.trailingAnchor, bottom: trackControl.bottomAnchor)
        
        let distanceUpIcon = UIImageView(image: UIImage(systemName: "arrow.up"))
        distanceUpIcon.tintColor = .darkGray
        trackControl.addSubview(distanceUpIcon)
        distanceUpIcon.setAnchors(top: trackControl.topAnchor, leading: distanceLabel.trailingAnchor, bottom: trackControl.bottomAnchor, insets: flatInsets)
        distanceUpLabel.textColor = .darkGray
        distanceUpLabel.text = "0m"
        trackControl.addSubview(distanceUpLabel)
        distanceUpLabel.setAnchors(top: trackControl.topAnchor, leading: distanceUpIcon.trailingAnchor, bottom: trackControl.bottomAnchor)
        
        let distanceDownIcon = UIImageView(image: UIImage(systemName: "arrow.down"))
        distanceDownIcon.tintColor = .darkGray
        trackControl.addSubview(distanceDownIcon)
        distanceDownIcon.setAnchors(top: trackControl.topAnchor, leading: distanceUpLabel.trailingAnchor, bottom: trackControl.bottomAnchor, insets: flatInsets)
        distanceDownLabel.textColor = .darkGray
        distanceDownLabel.text = "0m"
        trackControl.addSubview(distanceDownLabel)
        distanceDownLabel.setAnchors(top: trackControl.topAnchor, leading: distanceDownIcon.trailingAnchor, bottom: trackControl.bottomAnchor)
        
        let timeIcon = UIImageView(image: UIImage(systemName: "stopwatch"))
        timeIcon.tintColor = .darkGray
        trackControl.addSubview(timeIcon)
        timeIcon.setAnchors(top: trackControl.topAnchor, leading: distanceDownLabel.trailingAnchor, bottom: trackControl.bottomAnchor, insets: flatInsets)
        timeLabel.textColor = .darkGray
        trackControl.addSubview(timeLabel)
        timeLabel.setAnchors(top: trackControl.topAnchor, leading: timeIcon.trailingAnchor, bottom: trackControl.bottomAnchor)
        
        pauseResumeButton.tintColor = .darkGray
        trackControl.addSubview(pauseResumeButton)
        pauseResumeButton.setAnchors(top: trackControl.topAnchor, trailing: trackControl.trailingAnchor, bottom: trackControl.bottomAnchor, insets: flatInsets)
        updatePauseResumeButton()
        pauseResumeButton.addTarget(self, action: #selector(pauseResume), for: .touchDown)
        
        updateTrackInfo()
        //self.isHidden = true
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
            ($0 == topControl || $0 == trackControl || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    // top
    
    func getMapMenu() -> UIMenu{
        let preloadMapAction = UIAction(title: "preloadMaps".localize(), image: UIImage(systemName: "square.and.arrow.down")){ action in
            self.delegate?.preloadMap()
        }
        let deleteTilesAction = UIAction(title: "deleteTiles".localize(), image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deleteTiles()
        }
        return UIMenu(title: "", children: [preloadMapAction, deleteTilesAction])
    }
    
    @objc func togglePins(){
        Preferences.instance.showPins = !Preferences.instance.showPins
        delegate?.updatePinVisibility()
    }
    
    @objc func toggleTracking(){
        trackControl.isHidden = !trackControl.isHidden
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func toggleCross(){
        crossControl.isHidden = !crossControl.isHidden
    }
    
    @objc func openCamera(){
        delegate?.openCamera()
    }
    
    // license
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
    
    // cross
    
    func getCrossMenu() -> UIMenu{
        let addLocationAction = UIAction(title: "addLocation".localize(), image: UIImage(systemName: "mappin")){ action in
            self.delegate?.addLocation()
        }
        return UIMenu(title: "", children: [addLocationAction])
    }
    
    // track
    
    func startTrackInfo(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        updatePauseResumeButton()
    }
    
    func pauseTrackInfo(){
        updatePauseResumeButton()
    }
    
    func resumeTrackInfo(){
        updatePauseResumeButton()
    }
    
    func updateTrackInfo(){
        if let track = ActiveTrack.track{
            distanceLabel.text = "\(Int(track.distance))m"
            distanceUpLabel.text = "\(Int(track.upDistance))m"
            distanceDownLabel.text = "\(Int(track.downDistance))m"
        }
    }
    
    func stopTrackInfo(){
        trackControl.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    func startTrackControl(){
        trackControl.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        if let track = ActiveTrack.track{
            timeLabel.text = track.durationUntilNow.hmsString()
        }
    }
    
    @objc func pauseResume(){
        if let _ = ActiveTrack.track{
            if ActiveTrack.isTracking{
                ActiveTrack.pauseTracking()
            }
            else{
                ActiveTrack.resumeTracking()
            }
            updatePauseResumeButton()
        }
    }
    
    func updatePauseResumeButton(){
        if ActiveTrack.isTracking{
            pauseResumeButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        else{
            pauseResumeButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
}





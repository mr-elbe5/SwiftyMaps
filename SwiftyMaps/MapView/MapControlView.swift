/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol MapControlDelegate{
    func focusUserLocation()
    func addPlaceAtCross()
    func addPlaceAtUserPosition()
    func changeMap()
    func openInfo()
    func openCamera()
    func openTour()
    func openSearch()
    func openPreferences()
}

class MapControlView: UIView {
    
    var delegate : MapControlDelegate? = nil
    
    var toggleCrossControl = IconButton(icon: "plus.circle")
    var crossControl = IconButton(icon: "plus.circle")
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        let topStackView = UIStackView()
        topStackView.setupHorizontal(distribution: .equalSpacing, spacing: 0)
        topStackView.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.33)
        addSubview(topStackView)
        topStackView.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        
        let openCameraControl = IconButton(icon: "camera.circle")
        topStackView.addArrangedSubview(openCameraControl)
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        let openTourControl = IconButton(icon: "figure.walk.circle")
        topStackView.addArrangedSubview(openTourControl)
        openTourControl.addTarget(self, action: #selector(openTour), for: .touchDown)
        
        let openSearchControl = IconButton(icon: "magnifyingglass.circle")
        topStackView.addArrangedSubview(openSearchControl)
        openSearchControl.addTarget(self, action: #selector(openSearch), for: .touchDown)
        
        let openPreferencesControl = IconButton(icon: "gearshape.circle")
        topStackView.addArrangedSubview(openPreferencesControl)
        openPreferencesControl.addTarget(self, action: #selector(openPreferences), for: .touchDown)
        
        let openInfoControl = IconButton(icon: "info.circle")
        topStackView.addArrangedSubview(openInfoControl)
        openInfoControl.addTarget(self, action: #selector(openInfo), for: .touchDown)
        
        let bottomStackView = UIStackView()
        bottomStackView.setupHorizontal(distribution: .equalSpacing, spacing: 0)
        bottomStackView.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.33)
        addSubview(bottomStackView)
        bottomStackView.setAnchors(top: nil, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*Insets.defaultInset, bottom: 2*Insets.defaultInset, right: 2*Insets.defaultInset))
        
        let focusUserLocationControl = IconButton(icon: "record.circle")
        bottomStackView.addArrangedSubview(focusUserLocationControl)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        let addPlaceMarkerControl = IconButton(icon: "mappin.circle")
        bottomStackView.addArrangedSubview(addPlaceMarkerControl)
        addPlaceMarkerControl.addTarget(self, action: #selector(addPlaceAtUserPosition), for: .touchDown)
        
        bottomStackView.addArrangedSubview(toggleCrossControl)
        toggleCrossControl.addTarget(self, action: #selector(toggleCross), for: .touchDown)
        
        let changeMapControl = IconButton(icon: "map.circle")
        bottomStackView.addArrangedSubview(changeMapControl)
        changeMapControl.addTarget(self, action: #selector(changeMap), for: .touchDown)
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        crossControl.addTarget(self, action: #selector(placeCrossTouched), for: .touchDown)
        crossControl.isHidden = true
        
        addSubview(licenseView)
        licenseView.setAnchors(top: bottomStackView.bottomAnchor, leading: nil, trailing: layoutGuide.trailingAnchor, bottom: nil, insets: UIEdgeInsets(top: Insets.defaultInset, left: Insets.defaultInset, bottom: 0, right: Insets.defaultInset))
        
        MapType.current.fillLicenseView(licenseView)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 is UIStackView || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func toggleCross(){
        if crossControl.isHidden{
            crossControl.isHidden = false
            toggleCrossControl.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        }
        else{
            crossControl.isHidden = true
            toggleCrossControl.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        }
    }
    
    @objc func changeMap(){
        delegate?.changeMap()
        MapType.current.fillLicenseView(licenseView)
    }
    
    @objc func openInfo(){
        delegate?.openInfo()
    }
    
    @objc func openCamera(){
        delegate?.openCamera()
    }
    
    @objc func openTour(){
        delegate?.openTour()
    }
    
    @objc func openSearch(){
        delegate?.openSearch()
    }
    
    @objc func addPlaceAtUserPosition(){
        delegate?.addPlaceAtUserPosition()
    }
    
    @objc func placeCrossTouched(){
        delegate?.addPlaceAtCross()
    }
    
    @objc func openPreferences(){
        delegate?.openPreferences()
    }
    
}




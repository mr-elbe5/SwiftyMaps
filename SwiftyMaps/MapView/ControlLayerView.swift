/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol ControlLayerDelegate{
    func focusUserLocation()
    func addPlace()
    func changeMap()
    func preloadMap()
    func openInfo()
    func openCamera()
    func openTour()
    func openPreferences()
}

class ControlLayerView: UIView {
    
    var delegate : ControlLayerDelegate? = nil
    
    var preloadMapControl = IconButton(icon: "square.and.arrow.down", tintColor: .darkGray, disabledTintColor: .lightGray)
    var toggleCrossControl = IconButton(icon: "mappin.and.ellipse")
    var crossControl = IconButton(icon: "plus.circle")
    var licenseView = UIView()
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        let topControlLine = MapControlLine()
        topControlLine.setup()
        addSubview(topControlLine)
        topControlLine.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, insets: Insets.doubleInsets)
        
        let changeMapControl = IconButton(icon: "map")
        topControlLine.addSubview(changeMapControl)
        changeMapControl.setAnchors(top: topControlLine.topAnchor, leading: topControlLine.leadingAnchor, bottom: topControlLine.bottomAnchor, insets: Insets.flatInsets)
        changeMapControl.addTarget(self, action: #selector(changeMap), for: .touchDown)
        
        topControlLine.addSubview(preloadMapControl)
        preloadMapControl.setAnchors(top: topControlLine.topAnchor, leading: changeMapControl.trailingAnchor, bottom: topControlLine.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*Insets.defaultInset, bottom: 0, right: 0))
        preloadMapControl.addTarget(self, action: #selector(preloadMap), for: .touchDown)
        preloadMapControl.isEnabled = false
        
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
        openPreferencesControl.addTarget(self, action: #selector(openPreferences), for: .touchDown)

        let bottomControlLine = MapControlLine()
        bottomControlLine.setup()
        addSubview(bottomControlLine)
        bottomControlLine.setAnchors(leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 2*Insets.defaultInset, bottom: 2*Insets.defaultInset, right: 2*Insets.defaultInset))
        
        let openCameraControl = IconButton(icon: "camera")
        bottomControlLine.addSubview(openCameraControl)
        openCameraControl.setAnchors(top: bottomControlLine.topAnchor, leading: bottomControlLine.leadingAnchor, bottom: bottomControlLine.bottomAnchor, insets: Insets.flatInsets)
        openCameraControl.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        let openTourControl = IconButton(icon: "figure.walk")
        bottomControlLine.addSubview(openTourControl)
        openTourControl.setAnchors(top: bottomControlLine.topAnchor, trailing: bottomControlLine.trailingAnchor, bottom: bottomControlLine.bottomAnchor, insets: Insets.flatInsets)
        openTourControl.addTarget(self, action: #selector(openTour), for: .touchDown)
        
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
        
        MapType.current.fillLicenseView(licenseView)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 is MapControlLine || $0 is IconButton || $0 == licenseView) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func checkPreloadScale(scale: CGFloat){
        //print("preloadScale \(scale) compared to \(MapStatics.minPreloadScale)")
        preloadMapControl.isEnabled = scale >= MapStatics.minPreloadScale
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
    
    @objc func changeMap(){
        delegate?.changeMap()
        MapType.current.fillLicenseView(licenseView)
    }
    
    @objc func preloadMap(){
        delegate?.preloadMap()
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
    
    @objc func placeCrossTouched(){
        delegate?.addPlace()
    }
    
    @objc func openPreferences(){
        delegate?.openPreferences()
    }
    
}

class MapControlLine : UIView{
    
    func setup(){
        backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}





/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol MapControlDelegate{
    func focusUserLocation()
    func addAnnotationAtCross()
    func addAnnotationAtUserPosition()
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
        bottomStackView.setAnchors(top: nil, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: Insets.doubleInsets)
        
        let focusUserLocationControl = IconButton(icon: "record.circle")
        bottomStackView.addArrangedSubview(focusUserLocationControl)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        let addAnnotationControl = IconButton(icon: "mappin.circle")
        bottomStackView.addArrangedSubview(addAnnotationControl)
        addAnnotationControl.addTarget(self, action: #selector(addAnnotationAtUserPosition), for: .touchDown)
        
        bottomStackView.addArrangedSubview(toggleCrossControl)
        toggleCrossControl.addTarget(self, action: #selector(toggleCross), for: .touchDown)
        
        let changeMapControl = IconButton(icon: "map.circle")
        bottomStackView.addArrangedSubview(changeMapControl)
        changeMapControl.addTarget(self, action: #selector(changeMap), for: .touchDown)
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        crossControl.isHidden = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 is UIStackView || $0 is IconButton) && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func toggleCross(){
        if crossControl.isHidden{
            crossControl.isHidden = false
            toggleCrossControl.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        }
        else{
            crossControl.isHidden = true
            toggleCrossControl.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            delegate?.addAnnotationAtCross()
        }
    }
    
    @objc func changeMap(){
        delegate?.changeMap()
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
    
    @objc func addAnnotationAtUserPosition(){
        delegate?.addAnnotationAtUserPosition()
    }
    
    @objc func annotationCrossTouched(){
        delegate?.addAnnotationAtCross()
    }
    
    @objc func openPreferences(){
        delegate?.openPreferences()
    }
    
}




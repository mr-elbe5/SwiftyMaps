/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol MapControlDelegate{
    func focusUserLocation()
    func openPreferences()
    func openInfo()
    func addAnnotation()
}

class MapControlView: UIView {
    
    var delegate : MapControlDelegate? = nil
    
    var toggleCrossControl = MapControl(icon: "plus.circle")
    var crossControl = MapControl(icon: "plus.circle")
    
    func setup(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        let focusUserLocationControl = MapControl(icon: "record.circle")
        addSubview(focusUserLocationControl)
        focusUserLocationControl.setAnchors(top: nil, leading: layoutGuide.leadingAnchor, trailing: nil, bottom: layoutGuide.bottomAnchor, insets: Insets.doubleInsets)
        focusUserLocationControl.addTarget(self, action: #selector(focusUserLocation), for: .touchDown)
        
        let openSettingsControl = MapControl(icon: "gearshape")
        addSubview(openSettingsControl)
        openSettingsControl.setAnchors(top: nil, leading: nil, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: Insets.doubleInsets)
        openSettingsControl.addTarget(self, action: #selector(openPreferences), for: .touchDown)
        
        let openInfoControl = MapControl(icon: "info.circle")
        addSubview(openInfoControl)
        openInfoControl.setAnchors(top: layoutGuide.topAnchor, leading: nil, trailing: layoutGuide.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        openInfoControl.addTarget(self, action: #selector(openInfo), for: .touchDown)
        
        addSubview(toggleCrossControl)
        toggleCrossControl.setAnchors(centerX: centerXAnchor, centerY: nil)
        toggleCrossControl.setAnchors(top: nil, leading: nil, trailing: nil, bottom: layoutGuide.bottomAnchor, insets: Insets.doubleInsets)
        toggleCrossControl.addTarget(self, action: #selector(toggleCross), for: .touchDown)
        
        crossControl.tintColor = UIColor.red
        addSubview(crossControl)
        crossControl.setAnchors(centerX: centerXAnchor, centerY: centerYAnchor)
        let addAnnotationAction = UIAction(title: "Add annotation", image: UIImage(systemName: "mappin")){ action in
            self.delegate?.addAnnotation()
        }
        crossControl.menu = UIMenu(title: "", image: nil, children: [addAnnotationAction])
        crossControl.showsMenuAsPrimaryAction = true
        crossControl.isHidden = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is MapControl && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    @objc func focusUserLocation(){
        delegate?.focusUserLocation()
    }
    
    @objc func openPreferences(){
        delegate?.openPreferences()
    }
    
    @objc func openInfo(){
        delegate?.openInfo()
    }
    
    @objc func toggleCross(){
        crossControl.isHidden = !crossControl.isHidden
        toggleCrossControl.setImage(crossControl.isHidden ? UIImage(systemName: "plus.circle") : UIImage(systemName: "circle.slash"), for: .normal)
    }
    
    @objc func annotationCrossTouched(){
        delegate?.addAnnotation()
    }
    
}

class MapControl : UIButton{
    
    init(icon: String){
        super.init(frame: CGRect(x: 00, y: 00, width: 20, height: 20))
        layer.cornerRadius = 10
        layer.masksToBounds = true
        setImage(UIImage(systemName: icon), for: .normal)
        self.tintColor = .darkGray
        transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



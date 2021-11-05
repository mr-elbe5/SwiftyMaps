//
//  MapAnnotationControl.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

protocol MapAnnotationControlDelegate{
    func deleteAction(sender: MapAnnotationControl)
}

class MapAnnotationControl : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    var annotation : MapAnnotation
    
    var deleteActionIdentifier : UIAction.Identifier
    
    var delegate: MapAnnotationControlDelegate? = nil
    
    init(annotation: MapAnnotation){
        self.annotation = annotation
        deleteActionIdentifier = UIAction.Identifier(annotation.id.uuidString)
        super.init(frame: MapAnnotationControl.baseFrame)
        annotation.delegate = self
        setImage(MapStatics.mapPinImage, for: .normal)
    }
    
    deinit{
        annotation.delegate = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createMenu(){
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "mappin.slash")?.withTintColor(.systemRed), identifier: deleteActionIdentifier){ action in
            self.delegate?.deleteAction(sender: self)
        }
        self.menu = UIMenu(title: annotation.description, image: UIImage(systemName: "mappin")?.withTintColor(.systemRed), children: [deleteAction])
        showsMenuAsPrimaryAction = true
    }
    
    func updatePosition(to pos: CGPoint){
        frame = MapAnnotationControl.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        //print("new frame = \(frame) in \(superview!.bounds)")
        setNeedsDisplay()
    }
    
}

extension MapAnnotationControl: MapAnnotationDelegate{
    
    func descriptionChanged(annotation: MapAnnotation) {
        createMenu()
    }
    
}


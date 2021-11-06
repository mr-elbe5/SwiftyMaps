//
//  MapAnnotationControl.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

protocol MapAnnotationControlDelegate{
    func detailAction(sender: MapAnnotationControl)
    func editAction(sender: MapAnnotationControl)
    func deleteAction(sender: MapAnnotationControl)
}

class MapAnnotationControl : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    var annotation : MapAnnotation
    
    var delegate: MapAnnotationControlDelegate? = nil
    
    init(annotation: MapAnnotation){
        self.annotation = annotation
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
        let detailAction = UIAction(title: "Show Details", image: UIImage(systemName: "rectangle.and.text.magnifyingglass")){ action in
            self.delegate?.detailAction(sender: self)
        }
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")){ action in
            self.delegate?.editAction(sender: self)
        }
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "mappin.slash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deleteAction(sender: self)
        }
        self.menu = UIMenu(title: annotation.description, children: [detailAction, editAction, deleteAction])
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


//
//  MapAnnotationsView.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 30.10.21.
//

import UIKit

protocol MapAnnotationViewDelegate{
    func showAnnotation(annotation: MapAnnotation)
    func editAnnotation(annotation: MapAnnotation)
    func deleteAnnotation(annotation: MapAnnotation)
}

class MapAnnotationView: UIView {
    
    var delegate : MapAnnotationViewDelegate? = nil
    
    func setupAnnotations(){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let annotations = MapAnnotationCache.instance.annotationsInPlanetRect(MapStatics.planetRect)
        for annotation in annotations{
            addAnnotationControl(annotation: annotation)
        }
    }
    
    func addAnnotationControl(annotation: MapAnnotation){
        let control = MapAnnotationControl(annotation: annotation)
        addSubview(control)
        control.delegate = self
        control.createMenu()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is MapAnnotationControl && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        for sv in subviews{
            if let av = sv as? MapAnnotationControl{
                av.updatePosition(to: CGPoint(x: (av.annotation.planetPosition.x - normalizedOffset.point.x)*scale , y: (av.annotation.planetPosition.y - normalizedOffset.point.y)*scale))
            }
        }
    }
    
}

extension MapAnnotationView: MapAnnotationControlDelegate{
    
    func detailAction(sender: MapAnnotationControl) {
        delegate?.showAnnotation(annotation: sender.annotation)
    }
    
    func editAction(sender: MapAnnotationControl) {
        delegate?.editAnnotation(annotation: sender.annotation)
    }
    
    func deleteAction(sender: MapAnnotationControl) {
        subviews.first(where: {$0 == sender})?.removeFromSuperview()
        delegate?.deleteAnnotation(annotation: sender.annotation)
    }
    
    
}


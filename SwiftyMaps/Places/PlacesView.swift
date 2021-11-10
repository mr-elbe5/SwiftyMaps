//
//  OSM-Maps
//
//  Created by Michael Rönnau on 30.10.21.
//

import UIKit

protocol PlacesViewDelegate{
    func showPlaceDetails(place: PlaceData)
    func editPlaceData(place: PlaceData)
    func deletePlace(place: PlaceData)
}

class PlacesView: UIView {
    
    var delegate : PlacesViewDelegate? = nil
    
    func setupPlaceMarkers(){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let places = PlaceCache.instance.placesInPlanetRect(MapStatics.planetRect)
        for place in places{
            addPlaceMarker(place: place)
        }
    }
    
    func addPlaceMarker(place: PlaceData){
        let control = PlaceMarker(place: place)
        addSubview(control)
        control.delegate = self
        control.createMenu()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is PlaceMarker && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        for sv in subviews{
            if let av = sv as? PlaceMarker{
                av.updatePosition(to: CGPoint(x: (av.place.planetPosition.x - normalizedOffset.point.x)*scale , y: (av.place.planetPosition.y - normalizedOffset.point.y)*scale))
            }
        }
    }
    
}

extension PlacesView: PlaceMarkerDelegate{
    
    func detailAction(sender: PlaceMarker) {
        delegate?.showPlaceDetails(place: sender.place)
    }
    
    func editAction(sender: PlaceMarker) {
        delegate?.editPlaceData(place: sender.place)
    }
    
    func deleteAction(sender: PlaceMarker) {
        subviews.first(where: {$0 == sender})?.removeFromSuperview()
        delegate?.deletePlace(place: sender.place)
    }
    
    
}


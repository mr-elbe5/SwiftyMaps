//
//  OSM-Maps
//
//  Created by Michael Rönnau on 30.10.21.
//

import UIKit

protocol PlaceLayerViewDelegate{
    func showPlaceDetails(place: PlaceData)
    func editPlace(place: PlaceData)
    func deletePlace(place: PlaceData)
}

class PlaceLayerView: UIView {
    
    var delegate : PlaceLayerViewDelegate? = nil
    
    func setupPlaceMarkers(){
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let places = Places.instance.placesInPlanetRect(MapStatics.planetRect)
        for place in places{
            addPlaceView(place: place)
        }
    }
    
    func addPlaceView(place: PlaceData){
        let placeView = PlacePinView(place: place)
        addSubview(placeView)
        placeView.delegate = self
    }
    
    func getPlacePin(place: PlaceData) -> PlacePinView?{
        for subview in subviews{
            if let pin = subview as? PlacePinView, pin.place == place{
                return pin
            }
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            $0 is PlacePinView && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        for sv in subviews{
            if let av = sv as? PlacePinView{
                av.updatePosition(to: CGPoint(x: (av.place.location.planetPosition.x - normalizedOffset.point.x)*scale , y: (av.place.location.planetPosition.y - normalizedOffset.point.y)*scale))
            }
        }
    }
    
    func updatePlaceState(_ place: PlaceData){
        if let pin = getPlacePin(place: place){
            pin.updateImage()
        }
    }
    
}

extension PlaceLayerView: PlaceDelegate{
    
    func detailAction(sender: PlacePinView) {
        delegate?.showPlaceDetails(place: sender.place)
    }
    
    func editAction(sender: PlacePinView) {
        delegate?.editPlace(place: sender.place)
    }
    
    func deleteAction(sender: PlacePinView) {
        subviews.first(where: {$0 == sender})?.removeFromSuperview()
        delegate?.deletePlace(place: sender.place)
    }
    
    
}


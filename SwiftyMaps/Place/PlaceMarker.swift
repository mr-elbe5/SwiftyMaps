//
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

protocol PlaceMarkerDelegate{
    func detailAction(sender: PlaceMarker)
    func editAction(sender: PlaceMarker)
    func deleteAction(sender: PlaceMarker)
}

class PlaceMarker : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    var place : PlaceData
    
    var delegate: PlaceMarkerDelegate? = nil
    
    init(place: PlaceData){
        self.place = place
        super.init(frame: PlaceMarker.baseFrame)
        place.delegate = self
        setImage(MapStatics.mapPinImage, for: .normal)
    }
    
    deinit{
        place.delegate = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createMenu(){
        let detailAction = UIAction(title: "showDetails".localize(), image: UIImage(systemName: "rectangle.and.text.magnifyingglass")){ action in
            self.delegate?.detailAction(sender: self)
        }
        let editAction = UIAction(title: "edit".localize(), image: UIImage(systemName: "pencil")){ action in
            self.delegate?.editAction(sender: self)
        }
        let deleteAction = UIAction(title: "delete".localize(), image: UIImage(systemName: "mappin.slash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
            self.delegate?.deleteAction(sender: self)
        }
        let title = "\(place.locationString)\n(\(place.coordinateString))\n\(place.description)"
        self.menu = UIMenu(title: title, children: [detailAction, editAction, deleteAction])
        showsMenuAsPrimaryAction = true
    }
    
    func updatePosition(to pos: CGPoint){
        frame = PlaceMarker.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        //print("new frame = \(frame) in \(superview!.bounds)")
        setNeedsDisplay()
    }
    
}

extension PlaceMarker: PlaceDelegate{
    
    func descriptionChanged(place: PlaceData) {
        print("desc ch")
        createMenu()
    }
    
}


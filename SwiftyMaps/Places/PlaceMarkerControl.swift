//
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

protocol PlaceMarkerControlDelegate{
    func detailAction(sender: PlaceMarkerControl)
    func editAction(sender: PlaceMarkerControl)
    func deleteAction(sender: PlaceMarkerControl)
}

class PlaceMarkerControl : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    var place : PlaceData
    
    var delegate: PlaceMarkerControlDelegate? = nil
    
    init(place: PlaceData){
        self.place = place
        super.init(frame: PlaceMarkerControl.baseFrame)
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
        self.menu = UIMenu(title: place.description, children: [detailAction, editAction, deleteAction])
        showsMenuAsPrimaryAction = true
    }
    
    func updatePosition(to pos: CGPoint){
        frame = PlaceMarkerControl.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        //print("new frame = \(frame) in \(superview!.bounds)")
        setNeedsDisplay()
    }
    
}

extension PlaceMarkerControl: PlaceDelegate{
    
    func descriptionChanged(place: PlaceData) {
        createMenu()
    }
    
}


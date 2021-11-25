//
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

protocol PlaceDelegate{
    func detailAction(sender: PlacePinView)
    func editAction(sender: PlacePinView)
    func deleteAction(sender: PlacePinView)
}

class PlacePinView : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    var place : PlaceData
    
    var delegate: PlaceDelegate? = nil
    
    var image  : UIImage{
        get{
            if place.isTrackStart{
                if place.hasPhotos{
                    return MapStatics.mapPinTrackPhotoImage
                }
                else{
                    return MapStatics.mapPinTrackImage
                }
            }
            else{
                if place.hasPhotos{
                    return MapStatics.mapPinPhotoImage
                }
                else{
                    return MapStatics.mapPinImage
                }
            }
        }
    }
    
    init(place: PlaceData){
        self.place = place
        super.init(frame: PlacePinView.baseFrame)
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePosition(to pos: CGPoint){
        frame = PlacePinView.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        //print("new frame = \(frame) in \(superview!.bounds)")
        setNeedsDisplay()
    }
    
    func updateImage(){
        setImage(image, for: .normal)
    }
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let detailAction = UIAction(title: "showDetails".localize(), image: UIImage(systemName: "text.magnifyingglass")){ action in
                self.delegate?.detailAction(sender: self)
            }
            let editAction = UIAction(title: "edit".localize(), image: UIImage(systemName: "pencil")){ action in
                self.delegate?.editAction(sender: self)
            }
            let deleteAction = UIAction(title: "delete".localize(), image: UIImage(systemName: "mappin.slash")?.withTintColor(.red, renderingMode: .alwaysOriginal)){ action in
                self.delegate?.deleteAction(sender: self)
            }
            let title = "\(self.place.locationString)\n(\(self.place.coordinateString))\n\(self.place.description)"
            return UIMenu(title: title, children: [detailAction, editAction, deleteAction])
        })
    }
    
}



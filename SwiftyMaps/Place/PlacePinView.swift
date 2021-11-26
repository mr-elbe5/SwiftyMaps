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
    
    static var defaultPinColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
    static var photoPinColor = UIColor(red: 0.25, green: 0.5, blue: 1, alpha: 1)
    
    var place : PlaceData
    
    var delegate: PlaceDelegate? = nil
    
    var image  : UIImage{
        get{
            let col = place.hasPhotos ? PlacePinView.photoPinColor : PlacePinView.defaultPinColor
            var img : UIImage!
            if place.isTrackStart{
                img = MapStatics.mapPinEllipseImage.withTintColor(col, renderingMode: .alwaysOriginal)
            }
            else{
                img = MapStatics.mapPinImage.withTintColor(col, renderingMode: .alwaysOriginal)
            }
            let fy = img.size.height / bounds.size.height
            img = img.resize(size: CGSize(width: img.size.width/fy, height: bounds.size.height))
            return img
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



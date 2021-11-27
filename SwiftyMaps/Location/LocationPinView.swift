//
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

protocol LocationDelegate{
    func detailAction(sender: LocationPinView)
    func editAction(sender: LocationPinView)
    func deleteAction(sender: LocationPinView)
}

class LocationPinView : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    static var defaultPinColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
    static var photoPinColor = UIColor(red: 0.25, green: 0.5, blue: 1, alpha: 1)
    
    var location : Location
    
    var delegate: LocationDelegate? = nil
    
    var image  : UIImage{
        get{
            let col = location.hasPhotos ? LocationPinView.photoPinColor : LocationPinView.defaultPinColor
            var img : UIImage!
            if location.hasTracks{
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
    
    init(location: Location){
        self.location = location
        super.init(frame: LocationPinView.baseFrame)
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePosition(to pos: CGPoint){
        frame = LocationPinView.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        setNeedsDisplay()
    }
    
    func updateImage(){
        print("update image")
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
            let title = "\(self.location.locationString)\n(\(self.location.coordinateString))\n\(self.location.description)"
            return UIMenu(title: title, children: [detailAction, editAction, deleteAction])
        })
    }
    
}



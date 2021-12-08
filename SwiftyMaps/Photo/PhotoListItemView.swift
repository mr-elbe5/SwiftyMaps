/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol PhotoListItemDelegate{
    func viewPhoto(sender: PhotoListItemView)
    func sharePhoto(sender: PhotoListItemView)
    func deletePhoto(sender: PhotoListItemView)
}

class PhotoListItemView : UIView{
    
    var photoData : PhotoData
    
    var delegate : PhotoListItemDelegate? = nil
    
    init(data: PhotoData){
        self.photoData = data
        super.init(frame: .zero)
        let deleteButton = IconButton(icon: "xmark.circle")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchDown)
        addSubview(deleteButton)
        deleteButton.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: flatInsets)
        let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
        viewButton.addTarget(self, action: #selector(viewPhoto), for: .touchDown)
        addSubview(viewButton)
        viewButton.setAnchors(top: topAnchor, trailing: deleteButton.leadingAnchor, insets: flatInsets)
        let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue)
        shareButton.addTarget(self, action: #selector(sharePhoto), for: .touchDown)
        addSubview(shareButton)
        shareButton.setAnchors(top: topAnchor, trailing: viewButton.leadingAnchor, insets: flatInsets)
        let imageView = UIImageView()
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        imageView.image = photoData.getImage()
        imageView.setAnchors(top: shareButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: UIEdgeInsets(top: 2, left: 0, bottom: defaultInset, right: 0))
        imageView.setAspectRatioConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewPhoto(){
        delegate?.viewPhoto(sender: self)
    }
    
    @objc func sharePhoto(){
        delegate?.sharePhoto(sender: self)
    }
    
    @objc func deletePhoto(){
        delegate?.deletePhoto(sender: self)
    }
    
}


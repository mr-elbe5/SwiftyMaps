/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol PhotoViewDelegate{
    func viewPhoto(data: PhotoData)
    func sharePhoto(data: PhotoData)
}

class PhotoView : UIView{
    
    static func fromData(data : PhotoData,delegate : PhotoViewDelegate? = nil)  -> PhotoView{
        let itemView = PhotoView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var photoData : PhotoData? = nil
    
    var delegate : PhotoViewDelegate? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: PhotoData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.photoData = data
        imageView.image = data.getImage()
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue)
            shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
            sv.addArrangedSubview(shareButton)
        }
    }
    
    @objc func viewItem(){
        if let imageData = photoData{
            delegate?.viewPhoto(data: imageData)
        }
    }
    
    @objc func shareItem(){
        if let imageData = photoData{
            delegate?.sharePhoto(data: imageData)
        }
    }
    
}

class PhotoDetailView : UIView{
    
    var photoData : PhotoData? = nil
    
    var imageView = UIImageView()
    
    static func fromData(data : PhotoData)  -> PhotoDetailView{
        let itemView = PhotoDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    func setupView(data: PhotoData){
        imageView.setDefaults()
        addSubview(imageView)
        self.photoData = data
        imageView.image = data.getImage()
        imageView.fillView(view: self)
    }
    
}

protocol PhotoEditDelegate{
    func deletePhoto(sender: PhotoEditView)
}

class PhotoEditView : UIView, UITextViewDelegate{
    
    static func fromData(data : PhotoData)  -> PhotoEditView{
        let editView = PhotoEditView()
        editView.setupView(data: data)
        return editView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var photoData : PhotoData? = nil
    
    var imageView = UIImageView()
    var delegate : PhotoEditDelegate? = nil
    
    func setupView(data: PhotoData){
        self.photoData = data
        imageView.image = data.getImage()
        let deleteButton = IconButton(icon: "xmark.circle")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchDown)
        addSubview(deleteButton)
        deleteButton.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: flatInsets)
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        imageView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
    }
    
    @objc func deletePhoto(){
        delegate?.deletePhoto(sender: self)
    }
    
}

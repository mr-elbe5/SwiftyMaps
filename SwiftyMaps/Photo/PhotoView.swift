//
//  ImageItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoViewDelegate{
    func viewPhotoItem(data: PhotoData)
    func sharePhotoItem(data: PhotoData)
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
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        imageView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: Insets.defaultInsets)
        }
        else{
            imageView.bottom(bottomAnchor)
        }
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
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
            delegate?.viewPhotoItem(data: imageData)
        }
    }
    
    @objc func shareItem(){
        if let imageData = photoData{
            delegate?.sharePhotoItem(data: imageData)
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
        imageView.fillView(view: self, insets: .zero)
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
    var titleView = TextEditArea()
    
    var delegate : PhotoEditDelegate? = nil
    
    func setupView(data: PhotoData){
        self.photoData = data
        imageView.image = data.getImage()
        titleView.setText(data.title)
        let deleteButton = IconButton(icon: "xmark.circle")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchDown)
        addSubview(deleteButton)
        deleteButton.setAnchors(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, insets: Insets.flatInsets)
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar(doneTitle: "done".localize())
        imageView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        imageView.setAspectRatioConstraint()
        titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: Insets.flatInsets)
    }
    
    func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if photoData != nil{
            photoData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
    @objc func deletePhoto(){
        delegate?.deletePhoto(sender: self)
    }
    
}

//
//
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

class PlaceEditViewController: PopupViewController{
    
    var descriptionView = TextEditView()
    let photoStackView = UIStackView()
    
    var place: PlaceData? = nil
    
    var deletedPhotos = [PhotoData]()
    
    override func loadView() {
        title = "place".localize()
        super.loadView()
        scrollView.setupVertical()
        setupContent()
        setupKeyboard()
    }
    
    func setupContent(){
        if let place = place{
            var header = HeaderLabel(text: "placeData".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor)
            let locationLabel = TextLabel(text: place.locationString)
            contentView.addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let coordinateLabel = TextLabel(text: place.coordinateString)
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "description".localize())
            contentView.addSubview(header)
            header.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor)
            descriptionView = TextEditView.fromData(text: place.description)
            contentView.addSubview(descriptionView)
            descriptionView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            var lastControl : UIView = descriptionView
            if !place.photos.isEmpty{
                header = HeaderLabel(text: "photos".localize())
                contentView.addSubview(header)
                header.setAnchors(top: descriptionView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
                photoStackView.setupVertical()
                contentView.addSubview(photoStackView)
                photoStackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
                lastControl = photoStackView
                for photo in place.photos{
                    let imageView = PhotoEditView.fromData(data: photo)
                    imageView.delegate = self
                    photoStackView.addArrangedSubview(imageView)
                }
            }
            let saveButton = UIButton()
            saveButton.setTitle("save".localize(), for: .normal)
            saveButton.setTitleColor(.systemBlue, for: .normal)
            saveButton.addTarget(self, action: #selector(save), for: .touchDown)
            contentView.addSubview(saveButton)
            saveButton.setAnchors(top: lastControl.bottomAnchor, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
                .centerX(contentView.centerXAnchor)
        }
    }
    
    @objc func save(){
        if let place = place{
            place.description = descriptionView.text
            for photo in deletedPhotos{
                place.deletePhoto(photo: photo)
            }
            PlaceController.instance.save()
        }
        self.dismiss(animated: true)
    }
    
}

extension PlaceEditViewController: PhotoEditDelegate{
    
    func deletePhoto(sender: PhotoEditView) {
        if let photo = sender.photoData{
            deletedPhotos.append(photo)
            for subView in photoStackView.subviews{
                if subView == sender{
                    subView.isHidden = true
                    break
                }
            }
        }
    }
    
}

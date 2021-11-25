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
    
    override func loadView() {
        title = "place".localize()
        super.loadView()
        scrollView.setupVertical()
        setupContent()
        setupKeyboard()
    }
    
    override func setupHeaderView(){
        super.setupHeaderView()
        
        let addPhotoButton = IconButton(icon: "photo", tintColor: .white)
        headerView.addSubview(addPhotoButton)
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchDown)
        addPhotoButton.setAnchors(top: headerView.topAnchor, trailing: closeButton.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
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
            header = HeaderLabel(text: "photos".localize())
            contentView.addSubview(header)
            header.setAnchors(top: descriptionView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            photoStackView.setupVertical()
            contentView.addSubview(photoStackView)
            photoStackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            if !place.photos.isEmpty{
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
            saveButton.setAnchors(top: photoStackView.bottomAnchor, bottom: contentView.bottomAnchor, insets: doubleInsets)
                .centerX(contentView.centerXAnchor)
        }
    }
    
    @objc func addPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @objc func save(){
        if let place = place{
            place.description = descriptionView.text
            Places.instance.save()
        }
        self.dismiss(animated: true)
    }
    
}

extension PlaceEditViewController: PhotoEditDelegate{
    
    func deletePhoto(sender: PhotoEditView) {
        showApprove(title: "confirmDeletePhoto".localize(), text: "deletePhotoHint".localize()){
            if let place = self.place, let photo = sender.photoData{
                place.deletePhoto(photo: photo)
                for subView in self.photoStackView.subviews{
                    if subView == sender{
                        self.photoStackView.removeArrangedSubview(sender)
                        self.photoStackView.removeSubview(sender)
                        break
                    }
                }
            }
        }
    }
    
}

extension PlaceEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        let photo = PhotoData()
        if FileController.copyFile(fromURL: imageURL, toURL: photo.fileURL){
            place?.photos.append(photo)
            let imageView = PhotoEditView.fromData(data: photo)
            imageView.delegate = self
            photoStackView.addArrangedSubview(imageView)
        }
        picker.dismiss(animated: false)
    }
    
}

//
//
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

protocol LocationEditDelegate{
    func updateLocationState(location: Location)
}

class LocationEditViewController: PopupViewController{
    
    var descriptionView = TextEditView()
    let photoStackView = UIStackView()
    
    var location: Location? = nil
    var hadPhotos = false
    
    var delegate: LocationEditDelegate? = nil
    
    override func loadView() {
        title = "location".localize()
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
        if let location = location{
            hadPhotos = location.hasPhotos
            var header = HeaderLabel(text: "locationData".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor)
            let locationLabel = TextLabel(text: location.locationString)
            contentView.addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let coordinateLabel = TextLabel(text: location.coordinateString)
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "description".localize())
            contentView.addSubview(header)
            header.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor)
            descriptionView = TextEditView.fromData(text: location.description)
            contentView.addSubview(descriptionView)
            descriptionView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "photos".localize())
            contentView.addSubview(header)
            header.setAnchors(top: descriptionView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            photoStackView.setupVertical()
            contentView.addSubview(photoStackView)
            photoStackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            for photo in location.photos{
                let imageView = PhotoEditView.fromData(data: photo)
                imageView.delegate = self
                photoStackView.addArrangedSubview(imageView)
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
        var needsUpdate = false
        if let location = location{
            location.description = descriptionView.text
            Locations.instance.save()
            needsUpdate = location.hasPhotos != hadPhotos
        }
        self.dismiss(animated: true){
            if needsUpdate{
                self.delegate?.updateLocationState(location: self.location!)
            }
        }
    }
    
}

extension LocationEditViewController: PhotoEditDelegate{
    
    func deletePhoto(sender: PhotoEditView) {
        showApprove(title: "confirmDeletePhoto".localize(), text: "deletePhotoHint".localize()){
            if let location = self.location, let photo = sender.photoData{
                location.deletePhoto(photo: photo)
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

extension LocationEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        let photo = PhotoData()
        if FileController.copyFile(fromURL: imageURL, toURL: photo.fileURL){
            location?.photos.append(photo)
            let imageView = PhotoEditView.fromData(data: photo)
            imageView.delegate = self
            photoStackView.addArrangedSubview(imageView)
        }
        picker.dismiss(animated: false)
    }
    
}

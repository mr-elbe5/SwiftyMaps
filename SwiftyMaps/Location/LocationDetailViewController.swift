/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol LocationEditDelegate{
    func updateLocationLayer(location: Location?)
}

class LocationDetailViewController: PopupScrollViewController{
    
    let editButton = IconButton(icon: "pencil.circle", tintColor: .white)
    let deleteButton = IconButton(icon: "trash", tintColor: .white)
    
    let descriptionContainerView = UIView()
    var descriptionView : TextEditView? = nil
    let photoStackView = UIStackView()
    
    var editMode = false
    
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
        addPhotoButton.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        
        headerView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        editButton.setAnchors(top: headerView.topAnchor, leading: addPhotoButton.trailingAnchor, bottom: headerView.bottomAnchor, insets: wideInsets)
        
        headerView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteLocation), for: .touchDown)
        deleteButton.setAnchors(top: headerView.topAnchor, leading: editButton.trailingAnchor, bottom: headerView.bottomAnchor, insets: wideInsets)
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
            contentView.addSubview(descriptionContainerView)
            descriptionContainerView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            setupDescriptionContainerView()
            header = HeaderLabel(text: "photos".localize())
            contentView.addSubview(header)
            header.setAnchors(top: descriptionContainerView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            photoStackView.setupVertical()
            setupPhotoStackView()
            contentView.addSubview(photoStackView)
            photoStackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor)
        }
    }
    
    func setupDescriptionContainerView(){
        descriptionContainerView.removeAllSubviews()
        guard let location = location else {return}
        if editMode{
            descriptionView = TextEditView.fromData(text: location.description)
            descriptionContainerView.addSubview(descriptionView!)
            descriptionView!.setAnchors(top: descriptionContainerView.topAnchor, leading: descriptionContainerView.leadingAnchor, trailing: descriptionContainerView.trailingAnchor)
            let saveButton = UIButton()
            saveButton.setTitle("save".localize(), for: .normal)
            saveButton.setTitleColor(.systemBlue, for: .normal)
            saveButton.addTarget(self, action: #selector(save), for: .touchDown)
            descriptionContainerView.addSubview(saveButton)
            saveButton.setAnchors(top: descriptionView!.bottomAnchor, bottom: descriptionContainerView.bottomAnchor, insets: doubleInsets)
                .centerX(descriptionContainerView.centerXAnchor)
        }
        else{
            descriptionView = nil
            let descriptionLabel = TextLabel(text: location.description)
            descriptionContainerView.addSubview(descriptionLabel)
            descriptionLabel.setAnchors(top: descriptionContainerView.topAnchor, leading: descriptionContainerView.leadingAnchor, trailing: descriptionContainerView.trailingAnchor, bottom: descriptionContainerView.bottomAnchor)
        }
    }
    
    func setupPhotoStackView(){
        photoStackView.removeAllArrangedSubviews()
        photoStackView.removeAllSubviews()
        guard let location = location else {return}
        if editMode{
            for photo in location.photos{
                let imageView = PhotoEditView.fromData(data: photo)
                imageView.delegate = self
                photoStackView.addArrangedSubview(imageView)
            }
        }
        else{
            for photo in location.photos{
                let imageView = PhotoView.fromData(data: photo, delegate: self)
                photoStackView.addArrangedSubview(imageView)
            }
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
    
    @objc func toggleEditMode(){
        if editMode{
            editButton.tintColor = .white
            editMode = false
        }
        else{
            editButton.tintColor = .systemBlue
            editMode = true
        }
        setupDescriptionContainerView()
        setupPhotoStackView()
    }
    
    @objc func deleteLocation(){
        if let loc = location{
            showApprove(title: "confirmDeleteLocation".localize(), text: "deleteLocationInfo".localize()){
                Locations.deleteLocation(loc)
                self.dismiss(animated: true){
                    self.delegate?.updateLocationLayer(location: nil)
                }
            }
        }
    }
    
    @objc func save(){
        var needsUpdate = false
        if let location = location{
            location.description = descriptionView?.text ?? ""
            Locations.save()
            needsUpdate = location.hasPhotos != hadPhotos
        }
        self.dismiss(animated: true){
            if needsUpdate{
                self.delegate?.updateLocationLayer(location: self.location!)
            }
        }
    }
    
}

extension LocationDetailViewController: PhotoViewDelegate{
    
    func viewPhoto(data: PhotoData) {
        let photoViewController = PhotoViewController()
        photoViewController.uiImage = data.getImage()
        photoViewController.modalPresentationStyle = .fullScreen
        self.present(photoViewController, animated: true)
    }
    
    func sharePhoto(data: PhotoData) {
        let alertController = UIAlertController(title: title, message: "shareImage".localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "imageLibrary".localize(), style: .default) { action in
            FileController.copyImageToLibrary(name: data.fileName, fromDir: FileController.privateURL){ result in
                DispatchQueue.main.async {
                    switch result{
                    case .success:
                        self.showAlert(title: "success".localize(), text: "photoShared".localize())
                    case .failure(let err):
                        self.showAlert(title: "error".localize(), text: err.errorDescription!)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
}

extension LocationDetailViewController: PhotoEditDelegate{
    
    func deletePhoto(sender: PhotoEditView) {
        showApprove(title: "confirmDeletePhoto".localize(), text: "deletePhotoHint".localize()){
            if let location = self.location, let photo = sender.photoData{
                location.deletePhoto(photo: photo)
                self.delegate?.updateLocationLayer(location: location)
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

extension LocationDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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

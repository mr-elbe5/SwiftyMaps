/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol LocationViewDelegate{
    func updateLocationLayer()
    func showTrackOnMap(track: TrackData)
}

class LocationDetailViewController: PopupScrollViewController{
    
    let editButton = IconButton(icon: "pencil.circle", tintColor: .white)
    let deleteButton = IconButton(icon: "trash", tintColor: .white)
    
    let descriptionContainerView = UIView()
    var descriptionView : TextEditView? = nil
    let photoStackView = UIStackView()
    let trackStackView = UIStackView()
    
    var editMode = false
    
    var location: Location? = nil
    var hadPhotos = false
    
    var delegate: LocationViewDelegate? = nil
    
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
            var header = UILabel(header: "locationData".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, insets: defaultInsets)
            let locationLabel = UILabel(text: location.locationString)
            contentView.addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
            let coordinateLabel = UILabel(text: location.coordinateString)
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: flatInsets)
            header = UILabel(header: "description".localize())
            contentView.addSubview(header)
            header.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor, insets: defaultInsets)
            contentView.addSubview(descriptionContainerView)
            descriptionContainerView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            setupDescriptionContainerView()
            header = UILabel(header: "photos".localize())
            contentView.addSubview(header)
            header.setAnchors(top: descriptionContainerView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
            photoStackView.setupVertical()
            setupPhotoStackView()
            contentView.addSubview(photoStackView)
            photoStackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: 0, right: defaultInset))
            header = UILabel(header: "tracks".localize())
            contentView.addSubview(header)
            header.setAnchors(top: photoStackView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
            trackStackView.setupVertical()
            setupTrackStackView()
            contentView.addSubview(trackStackView)
            trackStackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: 0, right: defaultInset))
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
            saveButton.setAnchors(top: descriptionView!.bottomAnchor, bottom: descriptionContainerView.bottomAnchor, insets: defaultInsets)
                .centerX(descriptionContainerView.centerXAnchor)
        }
        else{
            descriptionView = nil
            let descriptionLabel = UILabel(text: location.description)
            descriptionContainerView.addSubview(descriptionLabel)
            descriptionLabel.setAnchors(top: descriptionContainerView.topAnchor, leading: descriptionContainerView.leadingAnchor, trailing: descriptionContainerView.trailingAnchor, bottom: descriptionContainerView.bottomAnchor)
        }
    }
    
    func setupPhotoStackView(){
        photoStackView.removeAllArrangedSubviews()
        photoStackView.removeAllSubviews()
        guard let location = location else {return}
        for photo in location.photos{
            photoStackView.addArrangedSubview(createPhotoView(photo: photo))
        }
    }
    
    private func createPhotoView(photo: PhotoData) -> UIView{
        let photoView = UIView()
        let imageView = UIImageView()
        imageView.setDefaults()
        imageView.setRoundedBorders()
        photoView.addSubview(imageView)
        imageView.image = photo.getImage()
        imageView.setAnchors(top: photoView.topAnchor, leading: photoView.leadingAnchor, trailing: photoView.trailingAnchor, bottom: photoView.bottomAnchor, insets: UIEdgeInsets(top: 25, left: 0, bottom: defaultInset, right: 0))
        imageView.setAspectRatioConstraint()
        let deleteButton = IconButton(icon: "xmark.circle")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.dataObject = photo
        deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchDown)
        photoView.addSubview(deleteButton)
        deleteButton.setAnchors(top: photoView.topAnchor, trailing: photoView.trailingAnchor, insets: flatInsets)
        let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
        viewButton.dataObject = photo
        viewButton.addTarget(self, action: #selector(viewPhoto), for: .touchDown)
        photoView.addSubview(viewButton)
        viewButton.setAnchors(top: photoView.topAnchor, trailing: deleteButton.leadingAnchor, insets: flatInsets)
        let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue)
        shareButton.dataObject = photo
        shareButton.addTarget(self, action: #selector(sharePhoto), for: .touchDown)
        photoView.addSubview(shareButton)
        shareButton.setAnchors(top: photoView.topAnchor, trailing: viewButton.leadingAnchor, insets: flatInsets)
        return photoView
    }
    
    func setupTrackStackView(){
        trackStackView.removeAllArrangedSubviews()
        trackStackView.removeAllSubviews()
        guard let location = location else {return}
        for track in location.tracks{
            trackStackView.addArrangedSubview(createTrackView(track: track))
        }
    }
    
    private func createTrackView(track: TrackData) -> UIView{
        let view = UIView()
        let trackView = UIView()
        trackView.setGrayRoundedBorders()
        view.addSubview(trackView)
        trackView.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0))
        let header = UILabel(header: track.description)
        trackView.addSubview(header)
        header.setAnchors(top: trackView.topAnchor, leading: trackView.leadingAnchor, insets: defaultInsets)
        let locationLabel = UILabel(text: track.startLocation?.locationString ?? "")
        trackView.addSubview(locationLabel)
        locationLabel.setAnchors(top: header.bottomAnchor, leading: trackView.leadingAnchor, trailing: trackView.trailingAnchor, insets: flatInsets)
        let coordinateLabel = UILabel(text: track.startLocation?.coordinateString ?? "")
        trackView.addSubview(coordinateLabel)
        coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: trackView.leadingAnchor, trailing: trackView.trailingAnchor, insets: flatInsets)
        let timeLabel = UILabel(text: "\(track.startTime.dateTimeString()) - \(track.endTime.dateTimeString())")
        trackView.addSubview(timeLabel)
        timeLabel.setAnchors(top: coordinateLabel.bottomAnchor, leading: trackView.leadingAnchor, trailing: trackView.trailingAnchor, insets: flatInsets)
        let distanceLabel = UILabel(text: "\("distance".localize()): \(Int(track.distance))m")
        trackView.addSubview(distanceLabel)
        distanceLabel.setAnchors(top: timeLabel.bottomAnchor, leading: trackView.leadingAnchor, insets: flatInsets)
        let upDistanceLabel = UILabel(text: "\("upDistance".localize()): \(Int(track.upDistance))m")
        trackView.addSubview(upDistanceLabel)
        upDistanceLabel.setAnchors(top: distanceLabel.bottomAnchor, leading: trackView.leadingAnchor, insets: flatInsets)
        let downDistanceLabel = UILabel(text: "\("downDistance".localize()): \(Int(track.downDistance))m")
        trackView.addSubview(downDistanceLabel)
        downDistanceLabel.setAnchors(top: upDistanceLabel.bottomAnchor, leading: trackView.leadingAnchor, insets: flatInsets)
        let durationLabel = UILabel(text: "\("duration".localize()): \(track.duration.hmsString())")
        trackView.addSubview(durationLabel)
        durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: trackView.leadingAnchor, bottom: trackView.bottomAnchor, insets: UIEdgeInsets(top: 0, left: defaultInset, bottom: defaultInset, right: defaultInset))
        let deleteButton = IconButton(icon: "xmark.circle")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.dataObject = track
        deleteButton.addTarget(self, action: #selector(deleteTrack), for: .touchDown)
        view.addSubview(deleteButton)
        deleteButton.setAnchors(top: view.topAnchor, trailing: view.trailingAnchor, insets: defaultInsets)
        let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue)
        shareButton.addTarget(self, action: #selector(shareTrack), for: .touchDown)
        view.addSubview(shareButton)
        shareButton.setAnchors(top: view.topAnchor, trailing: deleteButton.leadingAnchor, insets: defaultInsets)
        let showOnMapButton = IconButton(icon: "map", tintColor: .systemBlue)
        showOnMapButton.dataObject = track
        showOnMapButton.addTarget(self, action: #selector(showTrackOnMap), for: .touchDown)
        view.addSubview(showOnMapButton)
        showOnMapButton.setAnchors(top: view.topAnchor, trailing: shareButton.leadingAnchor, insets: defaultInsets)
        return view
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
                    self.delegate?.updateLocationLayer()
                }
            }
        }
    }
    
    @objc func viewPhoto(_ sender: AnyObject) {
        if let iconButton = sender as? IconButton, let photoData = iconButton.dataObject as? PhotoData{
            let photoViewController = PhotoViewController()
            photoViewController.uiImage = photoData.getImage()
            photoViewController.modalPresentationStyle = .fullScreen
            self.present(photoViewController, animated: true)
        }
    }
    
    @objc func sharePhoto(_ sender: AnyObject) {
        if let iconButton = sender as? IconButton, let photoData = iconButton.dataObject as? PhotoData{
            let alertController = UIAlertController(title: title, message: "shareImage".localize(), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "imageLibrary".localize(), style: .default) { action in
                FileController.copyImageToLibrary(name: photoData.fileName, fromDir: FileController.privateURL){ result in
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
    
    @objc func deletePhoto(_ sender: AnyObject) {
        if let iconButton = sender as? IconButton, let photoData = iconButton.dataObject as? PhotoData{
            showApprove(title: "confirmDeletePhoto".localize(), text: "deletePhotoHint".localize()){
                if let location = self.location{
                    location.deletePhoto(photo: photoData)
                    Locations.save()
                    self.delegate?.updateLocationLayer()
                    for subView in self.photoStackView.subviews{
                        if subView == iconButton.superview{
                            self.photoStackView.removeArrangedSubview(subView)
                            self.photoStackView.removeSubview(subView)
                            break
                        }
                    }
                }
            }
        }
    }
    
    @objc func showTrackOnMap(_ sender: AnyObject) {
        if let iconButton = sender as? IconButton, let trackData = iconButton.dataObject as? TrackData{
            self.dismiss(animated: true){
                self.delegate?.showTrackOnMap(track: trackData)
            }
        }
    }
    
    @objc func shareTrack(_ sender: AnyObject) {
        if let iconButton = sender as? IconButton, let trackData = iconButton.dataObject as? TrackData{
            //todo
        }
    }
    
    @objc func deleteTrack(_ sender: AnyObject) {
        if let iconButton = sender as? IconButton, let trackData = iconButton.dataObject as? TrackData{
            showApprove(title: "confirmDeleteTrack".localize(), text: "deleteTrackInfo".localize()){
                if let location = self.location{
                    location.deleteTrack(track: trackData)
                    Locations.save()
                    self.delegate?.updateLocationLayer()
                    for subView in self.trackStackView.subviews{
                        if subView == iconButton.superview{
                            self.trackStackView.removeArrangedSubview(subView)
                            self.trackStackView.removeSubview(subView)
                            break
                        }
                    }
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
                self.delegate?.updateLocationLayer()
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
            photoStackView.addArrangedSubview(createPhotoView(photo: photo))
        }
        picker.dismiss(animated: false)
    }
    
}

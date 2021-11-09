//
//  ImageCaptureViewController.swift
//
//  Created by Michael Rönnau on 23.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos


protocol PhotoCaptureDelegate{
    func photoCaptured(photo: MapAnnotationPhoto)
}

class PhotoCaptureViewController: CameraViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var qualityItems : Array<String> = ["speed".localize(),"balanced".localize(),"quality".localize()]
    
    var data : MapAnnotationPhoto!
    
    var delegate: PhotoCaptureDelegate? = nil
    
    var captureButton = CaptureButton()
    var photoQualityControl = UISegmentedControl(items: qualityItems)
    var flashButton = IconButton(icon: "bolt.badge.a", tintColor: .white)
    var cameraButton = IconButton(icon: "camera.rotate", tintColor: .white)
    
    private let photoOutput = AVCapturePhotoOutput()
    private var photoQuality: AVCapturePhotoOutput.QualityPrioritization = .balanced
    private var flashMode : AVCaptureDevice.FlashMode = Preferences.instance.flashMode
    
    override func addButtons(){
        buttonView.backgroundColor = .black
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchDown)
        bodyView.addSubview(captureButton)
        captureButton.setAnchors(top: nil, leading: nil, trailing: nil, bottom: buttonView.topAnchor, insets: Insets.defaultInsets)
            .centerX(bodyView.centerXAnchor)
            .width(50)
            .height(50)
        photoQualityControl.backgroundColor = .clear
        photoQualityControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        photoQualityControl.selectedSegmentIndex = 1
        photoQualityControl.selectedSegmentTintColor = UIColor.systemGray2
        photoQualityControl.addTarget(self, action: #selector(togglePhotoQuality), for: .valueChanged)
        buttonView.addSubview(photoQualityControl)
        photoQualityControl.setAnchors(top: buttonView.topAnchor, leading: buttonView.leadingAnchor, trailing: buttonView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        buttonView.addSubview(bottomView)
        bottomView.setAnchors(top: photoQualityControl.bottomAnchor, leading: buttonView.leadingAnchor, trailing: buttonView.trailingAnchor, bottom: buttonView.bottomAnchor, insets: Insets.defaultInsets)
        cameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        cameraButton.addTarget(self, action: #selector(changeCamera), for: .touchDown)
        bottomView.addSubview(cameraButton)
        cameraButton.setAnchors(top: bottomView.topAnchor, leading: nil, trailing: bottomView.trailingAnchor, bottom: bottomView.bottomAnchor, insets: .zero)
        flashButton.setImage(UIImage(systemName: "bolt.badge.a"), for: .normal)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchDown)
        bottomView.addSubview(flashButton)
        flashButton.setAnchors(top: bottomView.topAnchor, leading: nil, trailing: cameraButton.leadingAnchor, bottom: bottomView.bottomAnchor, insets: UIEdgeInsets(top: Insets.defaultInset, left: Insets.defaultInset, bottom: Insets.defaultInset, right: 2*Insets.defaultInset))
    }
    
    override func enableButtons(flag: Bool){
        enableCameraButtons(flag: flag)
    }
    
    override func enableCameraButtons(flag: Bool){
        captureButton.isEnabled = flag
        cameraButton.isEnabled = flag
        photoQualityControl.isEnabled = flag
    }
    
    func configurePhoto(){
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = false
            photoOutput.isDepthDataDeliveryEnabled = false
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = false
            photoOutput.enabledSemanticSegmentationMatteTypes = []
            photoOutput.maxPhotoQualityPrioritization = .quality
            photoQuality = .balanced
            
        } else {
            print("Could not add photo output to the session")
            isInputAvailable = false
            session.commitConfiguration()
            return
        }
    }
    
    override func configureSession(){
        isInputAvailable = true
        session.beginConfiguration()
        session.sessionPreset = .photo
        configureVideo()
        if !isInputAvailable{
            return
        }
        configurePhoto()
        if !isInputAvailable {
            return
        }
        
        photoQuality = .balanced
        session.commitConfiguration()
    }
    
    override func replaceVideoDevice(newVideoDevice videoDevice: AVCaptureDevice){
        let currentVideoDevice = self.videoDeviceInput.device
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            self.session.beginConfiguration()
            
            self.session.removeInput(self.videoDeviceInput)
            
            if self.session.canAddInput(videoDeviceInput) {
                NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: currentVideoDevice)
                NotificationCenter.default.addObserver(self, selector: #selector(self.subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: videoDeviceInput.device)
                
                self.session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                self.session.addInput(self.videoDeviceInput)
            }
            
            self.photoOutput.maxPhotoQualityPrioritization = .quality
            
            self.session.commitConfiguration()
            
        } catch {
            print("Error occurred while creating video device input: \(error)")
        }
    }
    
    @objc func toggleFlash() {
        switch flashMode{
        case .auto:
            flashMode = .on
            self.flashButton.setImage(UIImage(systemName: "bolt"), for: .normal)
            break
        case .on:
            flashMode = .off
            self.flashButton.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
            break
        default:
            flashMode = .auto
            self.flashButton.setImage(UIImage(systemName: "bolt.badge.a"), for: .normal)
            break
        }
        Preferences.instance.flashMode = flashMode
        Preferences.instance.save()
    }
    
    @objc func capturePhoto() {
        let videoPreviewLayerOrientation = preview.videoPreviewLayer.connection?.videoOrientation
        
        sessionQueue.async {
            if let photoOutputConnection = self.photoOutput.connection(with: .video) {
                photoOutputConnection.videoOrientation = videoPreviewLayerOrientation!
            }
            var photoSettings = AVCapturePhotoSettings()
            if  self.photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            }
            if self.videoDeviceInput.device.isFlashAvailable {
                //photoSettings.flashMode = self.flashMode
            }
            photoSettings.isHighResolutionPhotoEnabled = true
            
            if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
            }
            photoSettings.isDepthDataDeliveryEnabled = false
            
            photoSettings.photoQualityPrioritization = self.photoQuality
            // shutter animation
            DispatchQueue.main.async {
                self.preview.videoPreviewLayer.opacity = 0
                UIView.animate(withDuration: 0.25) {
                    self.preview.videoPreviewLayer.opacity = 1
                }
            }
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData){
                data.image = image
                delegate?.photoCaptured(photo: data)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func togglePhotoQuality() {
        let selectedQuality = photoQualityControl.selectedSegmentIndex
        sessionQueue.async {
            switch selectedQuality {
            case 0 :
                self.photoQuality = .speed
            case 1 :
                self.photoQuality = .balanced
            case 2 :
                self.photoQuality = .quality
            default:
                break
            }
        }
    }
    
    override func addObservers(){
        let keyValueObservation = session.observe(\.isRunning, options: .new) { _, change in
            guard let isSessionRunning = change.newValue else { return }
            DispatchQueue.main.async {
                // Only enable the ability to change camera if the device has more than one camera.
                self.cameraButton.isEnabled = isSessionRunning && self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1
                self.captureButton.isEnabled = isSessionRunning
                self.photoQualityControl.isEnabled = isSessionRunning
            }
        }
        keyValueObservations.append(keyValueObservation)
        super.addObservers()
    }
    
}

//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol PreferencesDelegate{
    func clearTileCache()
    func removeAnnotations()
}

class MapPreferencesViewController: UIViewController{
    
    var scrollView = UIScrollView()
    
    var cartoUrlTemplateField = UITextField()
    var topoUrlTemplateField = UITextField()
    var startWithLastPositionSwitch = UISwitch()
    var showUserDirectionSwitch = UISwitch()
    var showAnnotationsSwitch = UISwitch()
    
    var delegate : PreferencesDelegate? = nil
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        let layoutGuide = view.safeAreaLayoutGuide
        scrollView.setAnchors(top: layoutGuide.topAnchor, leading: layoutGuide.leadingAnchor, trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: .zero)
        scrollView.isScrollEnabled = true
        let scflg = scrollView.contentLayoutGuide
        let svflg = scrollView.frameLayoutGuide
        scflg.widthAnchor.constraint(equalTo: svflg.widthAnchor).isActive = true
        
        var label = UILabel()
        label.text = "URL Template for OpenStreetMap Carto Style:"
        scrollView.addSubview(label)
        label.setAnchors(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        cartoUrlTemplateField.autocapitalizationType = .none
        cartoUrlTemplateField.autocorrectionType = .no
        cartoUrlTemplateField.setKeyboardToolbar(doneTitle: "Done")
        scrollView.addSubview(cartoUrlTemplateField)
        cartoUrlTemplateField.setAnchors(top: label.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        cartoUrlTemplateField.text = MapType.carto.tileUrl
        
        label = UILabel()
        label.text = "URL Template for OpenTopoMap Style:"
        scrollView.addSubview(label)
        label.setAnchors(top: cartoUrlTemplateField.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        topoUrlTemplateField.autocapitalizationType = .none
        topoUrlTemplateField.autocorrectionType = .no
        topoUrlTemplateField.setKeyboardToolbar(doneTitle: "Done")
        scrollView.addSubview(topoUrlTemplateField)
        topoUrlTemplateField.setAnchors(top: label.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        topoUrlTemplateField.text = MapType.topo.tileUrl
        
        let clearTileCacheButton = UIButton()
        clearTileCacheButton.setTitle("Clear Tile Cache", for: .normal)
        clearTileCacheButton.setTitleColor(.systemBlue, for: .normal)
        clearTileCacheButton.addTarget(self, action: #selector(clearTileCache), for: .touchDown)
        scrollView.addSubview(clearTileCacheButton)
        clearTileCacheButton.setAnchors(top: topoUrlTemplateField.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        
        label = UILabel()
        label.text = "startWithLastPosition".localize()
        scrollView.addSubview(label)
        label.setAnchors(top: clearTileCacheButton.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        scrollView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: clearTileCacheButton.bottomAnchor, leading: nil, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        startWithLastPositionSwitch.isOn = Preferences.instance.startWithLastPosition
        
        label = UILabel()
        label.text = "Show User Direction:"
        scrollView.addSubview(label)
        label.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        scrollView.addSubview(showUserDirectionSwitch)
        showUserDirectionSwitch.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: nil, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        showUserDirectionSwitch.isOn = Preferences.instance.showUserDirection
        
        label = UILabel()
        label.text = "Show Annotations:"
        scrollView.addSubview(label)
        label.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        scrollView.addSubview((showAnnotationsSwitch))
        showAnnotationsSwitch.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: nil, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        showAnnotationsSwitch.isOn =  Preferences.instance.showAnnotations
        
        let removeAnnotationsButton = UIButton()
        removeAnnotationsButton.setTitle("Remove all annotations", for: .normal)
        removeAnnotationsButton.setTitleColor(.systemBlue, for: .normal)
        removeAnnotationsButton.addTarget(self, action: #selector(removeAnnotations), for: .touchDown)
        scrollView.addSubview(removeAnnotationsButton)
        removeAnnotationsButton.setAnchors(top: showAnnotationsSwitch.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        
        let okButton = UIButton()
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(.systemBlue, for: .normal)
        okButton.addTarget(self, action: #selector(ok), for: .touchDown)
        scrollView.addSubview(okButton)
        okButton.setAnchors(top: removeAnnotationsButton.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: scrollView.bottomAnchor, insets: Insets.doubleInsets)
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        scrollView.addSubview(cancelButton)
        cancelButton.setAnchors(top: removeAnnotationsButton.bottomAnchor, leading: nil, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor, insets: Insets.doubleInsets)
        setupKeyboard()
    }
    
    @objc func clearTileCache(){
        showApprove(title: "Really clear all tiles from cache?", text: "Tiles will have to be reloaded"){
            self.delegate?.clearTileCache()
        }
    }
    
    @objc func removeAnnotations(){
        showApprove(title: "Really delete all annotations?", text: "This cannot be undone"){
            self.delegate?.removeAnnotations()
        }
    }
    
    @objc func ok(){
        if let newTemplate = cartoUrlTemplateField.text, newTemplate != MapType.carto.tileUrl{
            MapType.carto.tileUrl = newTemplate
            _ = MapTileCache.clear()
        }
        if let newTemplate = topoUrlTemplateField.text, newTemplate != MapType.topo.tileUrl{
            MapType.topo.tileUrl = newTemplate
            _ = MapTileCache.clear()
        }
        Preferences.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        Preferences.instance.showUserDirection = showUserDirectionSwitch.isOn
        Preferences.instance.showAnnotations = showAnnotationsSwitch.isOn
        Preferences.instance.save()
        self.dismiss(animated: true)
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardDidShow(notification:NSNotification){
        if let firstResponder = scrollView.firstResponder{
            let rect : CGRect = firstResponder.frame
            var parentView = firstResponder.superview
            var offset : CGFloat = 0
            while parentView != nil && parentView != scrollView {
                offset += parentView!.frame.minY
                parentView = parentView?.superview
            }
            scrollView.scrollRectToVisible(.init(x: rect.minX, y: rect.minY + offset, width: rect.width, height: rect.height), animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}


//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import SwiftyIOSViewExtensions

class ConfigurationViewController: UIViewController{
    
    var scrollView = UIScrollView()
    
    var cartoUrlField = UITextField()
    var topoUrlField = UITextField()
    var startWithLastPositionSwitch = UISwitch()
    var showUserLocationSwitch = UISwitch()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.fillSafeAreaOf(view: view, insets: .zero)
        scrollView.setupVertical()
        var label = UILabel()
        label.text = "cartoUrl".localize()
        scrollView.addSubview(label)
        label.placeBelow(anchor: scrollView.topAnchor)
        cartoUrlField.setKeyboardToolbar(doneTitle: "done".localize())
        scrollView.addSubview(cartoUrlField)
        cartoUrlField.placeBelow(view: label)
        cartoUrlField.text = Settings.instance.cartoUrl
        label = UILabel()
        label.text = "topoUrl".localize()
        scrollView.addSubview(label)
        label.placeBelow(view: cartoUrlField)
        topoUrlField.setKeyboardToolbar(doneTitle: "done".localize())
        scrollView.addSubview(topoUrlField)
        topoUrlField.placeBelow(view: label)
        topoUrlField.text = Settings.instance.topoUrl
        label = UILabel()
        label.text = "startWithLastPosition".localize()
        scrollView.addSubview(label)
        label.placeFirstInRow(topAnchor: topoUrlField.bottomAnchor,insets: defaultInsets)
        scrollView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.placeLastInRow(leftAnchor: label.trailingAnchor, topAnchor: topoUrlField.bottomAnchor,insets: defaultInsets)
        startWithLastPositionSwitch.isOn = Settings.instance.startWithLastPosition
        label = UILabel()
        label.text = "showUserLocation".localize()
        scrollView.addSubview(label)
        label.placeFirstInRow(topAnchor: startWithLastPositionSwitch.bottomAnchor,insets: defaultInsets)
        scrollView.addSubview((showUserLocationSwitch))
        showUserLocationSwitch.placeLastInRow(leftAnchor: label.trailingAnchor, topAnchor: startWithLastPositionSwitch.bottomAnchor)
        showUserLocationSwitch.isOn =  Settings.instance.showUserLocation
        let okButton = UIButton()
        okButton.setTitle("ok".localize(), for: .normal)
        okButton.setTitleColor(.systemBlue, for: .normal)
        okButton.addTarget(self, action: #selector(ok), for: .touchDown)
        scrollView.addSubview(okButton)
        okButton.placeFirstInRow(topAnchor: showUserLocationSwitch.bottomAnchor)
            .connectBottom()
        let cancelButton = UIButton()
        cancelButton.setTitle("cancel".localize(), for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        scrollView.addSubview(cancelButton)
        cancelButton.placeLastInRow(leftAnchor: okButton.trailingAnchor, topAnchor: showUserLocationSwitch.bottomAnchor)
            .connectBottom()
        setupKeyboard()
    }
    
    @objc func ok(){
        Settings.instance.cartoUrl = cartoUrlField.text ?? ""
        Settings.instance.topoUrl = topoUrlField.text ?? ""
        Settings.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        Settings.instance.showUserLocation = showUserLocationSwitch.isOn
        Settings.instance.save()
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


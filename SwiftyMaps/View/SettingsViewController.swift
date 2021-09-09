//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import SwiftyIOSViewExtensions

enum SettingsPickerType{
    case backup
}

class SettingsViewController: EditViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    static var sizeItems : Array<String> = ["small".localize(),"medium".localize(),"large".localize()]

    var mapStartSizeControl = UISegmentedControl(items: sizeItems)
    
    var pickerType : SettingsPickerType? = nil
    
    override func loadView() {
        super.loadView()
        let mapSizeHeader = InfoHeader(text: "mapStartSize".localize())
        mapStartSizeControl.setTitleTextAttributes([.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        mapStartSizeControl.selectedSegmentIndex = Settings.shared.mapStartSizeIndex
        mapStartSizeControl.addTarget(self, action: #selector(toggleMapStartSize), for: .valueChanged)
        stackView.addArrangedSubview(mapSizeHeader)
        stackView.addArrangedSubview(mapStartSizeControl)
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(rightStackView)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        
        self.headerView = headerView
    }
    
    @objc func toggleMapStartSize() {
        let selectedSize = mapStartSizeControl.selectedSegmentIndex
        switch selectedSize {
        case 0 :
            Settings.shared.mapStartSize = .small
            break
        case 1 :
            Settings.shared.mapStartSize = .mid
            break
        case 2 :
            Settings.shared.mapStartSize = .large
            break
        default:
            break
        }
        Settings.shared.save()
    }
    
}


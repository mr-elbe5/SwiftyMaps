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
    
    var pickerType : SettingsPickerType? = nil
    
    override func loadView() {
        super.loadView()
        let mapSizeHeader = InfoHeader(text: "mapStartSize".localize())

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
    
}


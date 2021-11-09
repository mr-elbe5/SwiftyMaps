//
//  SwitchView.swift
//
//  Created by Michael Rönnau on 15.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

protocol SwitchDelegate{
    func switchValueDidChange(sender: LabeledSwitchView,isOn: Bool)
}

class LabeledSwitchView : UIView{
    
    private var label = UILabel()
    private var switcher = UISwitch()
    
    var delegate : SwitchDelegate? = nil
    
    var isOn : Bool{
        get{
            switcher.isOn
        }
        set{
            switcher.isOn = newValue
        }
    }
    
    func setupView(labelText: String, isOn : Bool){
        label.text = labelText
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        addSubview(label)
        switcher.scaleBy(0.75)
        switcher.isOn = isOn
        switcher.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        addSubview(switcher)
        label.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, insets: .zero)
        switcher.setAnchors(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, insets: .zero)
    }
    
    func setEnabled(_ flag: Bool){
        switcher.isEnabled = flag
    }
    
    @objc func valueDidChange(sender:UISwitch){
        delegate?.switchValueDidChange(sender: self,isOn: sender.isOn)
    }
    
}


//
//  TextEditLine.swift
//
//  Created by Michael Rönnau on 28.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

class LabeledTextField : UIView, UITextFieldDelegate{
    
    private var label = UILabel()
    private var textField = UITextField()
    
    var text: String{
        get{
            return textField.text ?? ""
        }
    }
    
    func setupView(labelText: String, text: String = "", isHorizontal : Bool = true){
        label.text = labelText
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        addSubview(label)
        textField.setDefaults()
        textField.text = text
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        addSubview(textField)
        textField.setKeyboardToolbar(doneTitle: "done".localize())
        if isHorizontal{
            label.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: centerXAnchor, bottom: bottomAnchor)
            textField.setAnchors(top: topAnchor, leading: centerXAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        }
        else{
            label.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
            textField.setAnchors(top: label.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        }
    }
    
}


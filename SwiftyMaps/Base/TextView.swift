//
//  TextItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TextView : UIView{
    
    static func fromData(text : String)  -> TextView{
        let textView = TextView()
        textView.setupView(text: text)
        return textView
    }
    
    var textView = UILabel()
    
    
    func setupView(text: String){
        textView.numberOfLines = 0
        addSubview(textView)
        textView.text = text
        textView.fillView(view: self, insets: Insets.defaultInsets)
    }
    
}

protocol TextEditDelegate{
    func textDidChange(sender: TextEditView, text: String)
}

class TextEditView : UIView, UITextViewDelegate{
    
    static func fromData(text : String, placeHolder: String = "")  -> TextEditView{
        let editView = TextEditView()
        editView.setupView(text: text, placeholder: placeHolder)
        return editView
    }
    
    var textView = TextEditArea()
    
    var delegate : TextEditDelegate? = nil
    
    private func setupView(text: String, placeholder: String){
        textView.setText(text)
        textView.placeholder = placeholder
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar(doneTitle: "done".localize())
        textView.fillView(view: self, insets: Insets.defaultInsets)
    }
    
    func setFocus(){
        textView.becomeFirstResponder()
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        (textView as! TextEditArea).textDidChange()
        delegate?.textDidChange(sender: self, text: textView.text)
    }

}


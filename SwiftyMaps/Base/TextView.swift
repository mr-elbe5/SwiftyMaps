/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
        textView.fillView(view: self, insets: defaultInsets)
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
    
    var text : String{
        textView.text
    }
    
    var delegate : TextEditDelegate? = nil
    
    private func setupView(text: String, placeholder: String){
        textView.setText(text)
        textView.placeholder = placeholder
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar(doneTitle: "done".localize())
        textView.fillView(view: self, insets: defaultInsets)
    }
    
    func setFocus(){
        textView.becomeFirstResponder()
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        (textView as! TextEditArea).textDidChange()
        delegate?.textDidChange(sender: self, text: textView.text)
    }

}


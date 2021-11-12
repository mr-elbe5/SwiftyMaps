//
//
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

class PlaceEditViewController: PopupViewController, UITextViewDelegate{
    
    var stackView = UIStackView()
    var descriptionView : TextEditView? = nil
    
    var place: PlaceData? = nil
    
    override func loadView() {
        title = "place".localize()
        super.loadView()
        scrollView.setupVertical()
        contentView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: Insets.narrowInsets)
        stackView.setupVertical()
        setupContent()
        setupKeyboard()
    }
    
    func setupContent(){
        if let place = place{
            let header = TextView.fromData(text: "description".localize())
            stackView.addArrangedSubview(header)
            descriptionView = TextEditView.fromData(text: place.description)
            descriptionView?.delegate = self
            stackView.addArrangedSubview(descriptionView!)
            if !place.photos.isEmpty{
                let header = TextView.fromData(text: "photos".localize())
                stackView.addArrangedSubview(header)
                for photo in place.photos{
                    let imageView = PhotoEditView.fromData(data: photo)
                    stackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        if place != nil{
            place!.description = textView.text!.trim()
        }
        (textView as! TextEditArea).textDidChange()
    }

    
}

extension PlaceEditViewController : TextEditDelegate{
    
    func textDidChange(sender: TextEditView, text: String) {
        if sender == descriptionView{
            place?.description = text
        }
    }
    
}

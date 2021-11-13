//
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

class PlaceDetailViewController: PopupViewController{
    
    var stackView = UIStackView()
    
    var place: PlaceData? = nil
    
    override func loadView() {
        title = "place".localize()
        super.loadView()
        scrollView.setupVertical()
        contentView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: Insets.narrowInsets)
        setupContent()
        stackView.setupVertical()
    }
    
    func setupContent(){
        if let place = place{
            let descriptionView = TextView.fromData(text: place.description)
            stackView.addArrangedSubview(descriptionView)
            if !place.photos.isEmpty{
                for photo in place.photos{
                    let imageView = PhotoView.fromData(data: photo)
                    stackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
}

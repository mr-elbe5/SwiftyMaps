//
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

class PlaceDetailViewController: PopupViewController{
    
    var place: PlaceData? = nil
    
    override func loadView() {
        title = "place".localize()
        super.loadView()
        scrollView.setupVertical()
        setupContent()
    }
    
    func setupContent(){
        if let place = place{
            var header = HeaderLabel(text: "placeData".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor)
            let locationLabel = TextLabel(text: place.locationString)
            contentView.addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let coordinateLabel = TextLabel(text: place.coordinateString)
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "description".localize())
            contentView.addSubview(header)
            header.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let descriptionLabel = TextLabel(text: place.description)
            contentView.addSubview(descriptionLabel)
            descriptionLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            if !place.photos.isEmpty{
                header = HeaderLabel(text: "photos".localize())
                contentView.addSubview(header)
                header.setAnchors(top: descriptionLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
                let stackView = UIStackView()
                stackView.setupVertical()
                contentView.addSubview(stackView)
                stackView.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor)
                for photo in place.photos{
                    let imageView = PhotoView.fromData(data: photo)
                    stackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
}

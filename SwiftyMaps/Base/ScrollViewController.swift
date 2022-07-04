/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class ScrollViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var scrollVertical : Bool = true
    var scrollHorizontal : Bool = false
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0))
        scrollView.addSubview(contentView)
        contentView.setAnchors(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor)
        if scrollVertical{
            contentView.bottom(scrollView.bottomAnchor)
        }
        else{
            contentView.height(scrollView.heightAnchor)
        }
        if scrollHorizontal{
            contentView.trailing(scrollView.trailingAnchor)
        }
        else{
            contentView.width(scrollView.widthAnchor)
        }
    }
    
}

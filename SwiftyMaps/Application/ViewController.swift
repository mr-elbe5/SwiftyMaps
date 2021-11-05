/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var mapView : MapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MapView(controller: self)
        view.addSubview(mapView)
        mapView.fillView(view: view)
        self.mapView = mapView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView?.connectLocationService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView?.disconnectLocationService()
    }
    
}




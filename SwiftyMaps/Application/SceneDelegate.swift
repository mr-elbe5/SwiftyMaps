/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FileController.initialize()
        Preferences.loadInstance()
        LocationPool.load()
        TrackPool.load()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        mainTabController = MainTabController()
        window?.rootViewController = mainTabController
        window?.makeKeyAndVisible()
        LocationService.shared.requestWhenInUseAuthorization()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        LocationService.shared.stop()
        FileController.deleteTemporaryFiles()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if !LocationService.shared.running{
            LocationService.shared.start()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if TrackPool.isTracking{
            if !LocationService.shared.authorizedAlways{
                LocationService.shared.requestAlwaysAuthorization()
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        LocationService.shared.start()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationPool.save()
        if !TrackPool.isTracking{
            LocationService.shared.stop()
        }
        Preferences.instance.save()
        mapViewController.mapView.savePosition()
    }

}

var mainTabController : MainTabController!

var mapViewController : MapViewController{
    mainTabController.getViewController(tag: .map) as! MapViewController
}

var locationsViewController : LocationsViewController{
    mainTabController.getViewController(tag: .locations) as! LocationsViewController
}

var tracksViewController : TracksViewController{
    mainTabController.getViewController(tag: .tracks) as! TracksViewController
}




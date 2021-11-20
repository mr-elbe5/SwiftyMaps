//
//  SceneDelegate.swift
//  SwiftyMapViewer
//
//  Created by Michael Rönnau on 09.09.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FileController.initialize()
        Preferences.loadInstance()
        PlaceController.loadInstance()
        TrackController.loadInstance()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        mainController = MapViewController()
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()
        LocationService.shared.requestWhenInUseAuthorization()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        LocationService.shared.start()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        TrackController.instance.save()
        PlaceController.instance.save()
        LocationService.shared.stop()
        Preferences.instance.save()
    }


}

var mainController : MapViewController? = nil


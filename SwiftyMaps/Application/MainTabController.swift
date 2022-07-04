
import UIKit

enum TabTags{
    case map, compass, locations, tracks, info
}

class MainTabController: UITabBarController {
    
    static var instance : MainTabController{
        get{
            return UIApplication.shared.windows.first!.rootViewController as! MainTabController
        }
    }
    
    override func loadView() {
        super.loadView()
        tabBar.barTintColor = UIColor.systemBackground
        tabBar.isTranslucent = false
        let mapViewcontroller = MapViewController()
        mapViewcontroller.tabBarItem = UITabBarItem(title: NSLocalizedString("map", comment: ""), image: UIImage(systemName: "globe"), tag: TabTags.map.hashValue)
        let compassViewController = CompassViewController()
        compassViewController.tabBarItem = UITabBarItem(title: "compass".localize(), image: UIImage(systemName: "safari"), tag: TabTags.compass.hashValue)
        let locationsViewController = LocationsViewController()
        locationsViewController.tabBarItem = UITabBarItem(title: "locations".localize(), image: UIImage(systemName: "mappin.and.ellipse"), tag: TabTags.locations.hashValue)
        let tracksViewController = TracksViewController()
        tracksViewController.tabBarItem = UITabBarItem(title: "tracks".localize(), image: UIImage(systemName: "figure.walk"), tag: TabTags.tracks.hashValue)
        let infoViewController = InfoViewController()
        infoViewController.tabBarItem = UITabBarItem(title: "info".localize(), image: UIImage(systemName: "info"), tag: TabTags.info.hashValue)
        let tabBarList = [mapViewcontroller, compassViewController, locationsViewController, tracksViewController, infoViewController]
        viewControllers = tabBarList
        selectedViewController = mapViewcontroller
    }
    
    static func getViewController(tag: TabTags) -> UIViewController?{
        let viewController = instance
        for viewController in viewController.viewControllers!{
            if viewController.tabBarItem!.tag == tag.hashValue{
                return viewController
            }
        }
        return nil
    }
    
    static func getMapViewController() -> MapViewController{
        return getViewController(tag: .map) as! MapViewController
    }
    
    static func getMapViewController() -> CompassViewController{
        return getViewController(tag: .compass) as! CompassViewController
    }
    
    static func getLocationsViewController() -> LocationsViewController{
        return getViewController(tag: .locations) as! LocationsViewController
    }
    
    static func getTracksViewController() -> TracksViewController{
        return getViewController(tag: .tracks) as! TracksViewController
    }
    
    static func getInfoViewController() -> InfoViewController{
        return getViewController(tag: .info) as! InfoViewController
    }

}



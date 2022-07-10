
import UIKit

enum TabTags{
    case map, locations, tracks, info, preferences, status
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
        tabBar.tintColor = UIColor.darkGray
        tabBar.isTranslucent = true
        let mapViewcontroller = MapViewController()
        mapViewcontroller.tabBarItem = UITabBarItem(title: NSLocalizedString("map", comment: ""), image: UIImage(systemName: "globe"), tag: TabTags.map.hashValue)
        let locationsViewController = LocationsViewController()
        locationsViewController.tabBarItem = UITabBarItem(title: "locations".localize(), image: UIImage(systemName: "mappin.and.ellipse"), tag: TabTags.locations.hashValue)
        let tracksViewController = TracksViewController()
        tracksViewController.tabBarItem = UITabBarItem(title: "tracks".localize(), image: UIImage(systemName: "figure.walk"), tag: TabTags.tracks.hashValue)
        let infoViewController = InfoViewController()
        infoViewController.tabBarItem = UITabBarItem(title: "info".localize(), image: UIImage(systemName: "info"), tag: TabTags.info.hashValue)
        let preferencesViewController = PreferencesViewController()
        preferencesViewController.tabBarItem = UITabBarItem(title: "preferences".localize(), image: UIImage(systemName: "gearshape"), tag: TabTags.preferences.hashValue)
        let statusViewController = StatusViewController()
        statusViewController.tabBarItem = UITabBarItem(title: "status".localize(), image: UIImage(systemName: "waveform"), tag: TabTags.status.hashValue)
        let tabBarList = [mapViewcontroller, locationsViewController, tracksViewController, infoViewController, preferencesViewController, statusViewController]
        viewControllers = tabBarList
        selectedViewController = mapViewcontroller
    }
    
    func getViewController(tag: TabTags) -> UIViewController?{
        for viewController in MainTabController.instance.viewControllers!{
            if viewController.tabBarItem!.tag == tag.hashValue{
                return viewController
            }
        }
        return nil
    }
    
    func switchToTab(tag: TabTags){
        selectedViewController = getViewController(tag: tag);
    }

}



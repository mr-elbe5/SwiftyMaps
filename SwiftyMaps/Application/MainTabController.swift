
import UIKit

enum TabTags{
    case map, locations, tracks, info, preferences
}

class MainTabController: UITabBarController {
    
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
        let preferencesViewController = PreferencesViewController()
        preferencesViewController.tabBarItem = UITabBarItem(title: "preferences".localize(), image: UIImage(systemName: "slider.horizontal.3"), tag: TabTags.preferences.hashValue)
        let infoViewController = InfoViewController()
        infoViewController.tabBarItem = UITabBarItem(title: "info".localize(), image: UIImage(systemName: "info"), tag: TabTags.info.hashValue)
        let tabBarList = [mapViewcontroller, locationsViewController, tracksViewController, preferencesViewController, infoViewController]
        viewControllers = tabBarList
        selectedViewController = mapViewcontroller
    }
    
    func getViewController(tag: TabTags) -> UIViewController?{
        for viewController in mainTabController.viewControllers!{
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




//
//  MainTabController.swift
//
//  Created by Michael Rönnau on 14.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

enum TabTags{
    case map, info, settings
}

class MainTabController: UITabBarController {
    
    static var instance : MainTabController{
        get{
            return UIApplication.shared.windows.first!.rootViewController as! MainTabController
        }
    }
    
    override func loadView() {
        super.loadView()
        tabBar.barTintColor = Statics.tabColor
        tabBar.isTranslucent = false
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "map".localize(), image: UIImage(systemName: "globe"), tag: TabTags.map.hashValue)
        let infoViewController = AppInfoViewController()
        infoViewController.tabBarItem = UITabBarItem(title: "info".localize(), image: UIImage(systemName: "info"), tag: TabTags.info.hashValue)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "settings".localize(), image: UIImage(systemName: "gear"), tag: TabTags.settings.hashValue)
        let tabBarList = [mapViewController, infoViewController, settingsViewController]
        viewControllers = tabBarList
        selectedViewController = mapViewController
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
    
    static func getMapViewController() -> MapViewController?{
        return getViewController(tag: .map) as! MapViewController?
    }
    
    static func getInfoViewController() -> InfoViewController?{
        return getViewController(tag: .info) as! InfoViewController?
    }
    
    static func getSettingsViewController() -> SettingsViewController?{
        return getViewController(tag: .settings) as! SettingsViewController?
    }

}



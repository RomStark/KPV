//
//  TabViewController.swift
//  Charity
//
//  Created by Al Stark on 30.11.2022.
//

import UIKit

class TabViewController: UITabBarController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
    func generateTabBar() {
        viewControllers = [
            generateVC(viewcontroller: UINavigationController(rootViewController: MainTableViewController()), title: "таблица", image: UIImage(systemName: "list.bullet.circle.fill")),
            generateVC(viewcontroller: MapViewController(), title: "карта", image: UIImage(systemName: "map.circle")),
            generateVC(viewcontroller: UINavigationController(rootViewController: AccauntViewController()) , title: "профиль", image: UIImage(systemName: "person")),
        ]
    }
    
    func generateVC(viewcontroller: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewcontroller.tabBarItem.title = title
        viewcontroller.tabBarItem.image = image
        return viewcontroller
    }

}

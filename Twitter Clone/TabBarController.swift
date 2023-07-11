//
//  ViewController.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 9.07.23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationViewController())
        let vc4 = UINavigationController(rootViewController: MessagesViewController())

        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "bell")
        vc4.tabBarItem.image = UIImage(systemName: "message")

//        vc1.title = "Home"
//        vc2.title = "Search"
//        vc3.title = "Notification"
//        vc4.title = "Messages"

        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        tabBar.tintColor = .label

    }


}


//
//  MainViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

private let divilerMargin: CGFloat = 80

class MainViewController: UITabBarController {
    
    // MARK: - Properties
    
    private var tabBarItemInsets: UIEdgeInsets {
        UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    // MARK: - Controllers
    
    private lazy var waterManagerVC: UIViewController = {
        return buildNavigationController(WaterManagerViewControllerBuilder.build(),
                                         title: "Трекер водички",
                                         icon: R.image.waterIcon(),
                                         tag: 0)
    }()
    
    private lazy var articlesVC: UIViewController = {
        return buildNavigationController(ArticlesViewControllerBuilder.build(),
                                         title: "Полезные статьи",
                                         icon: R.image.articleIcon(),
                                         tag: 1)
    }()
    
//    private lazy var sleepManagerVC: UIViewController = {
//        let controller = SleepManagerViewControllerBuilder.build()
//        controller.tabBarItem = UITabBarItem(title: nil, image: R.image.sleepIcon(), tag: 2)
//        controller.tabBarItem.imageInsets = tabBarItemInsets
//        return controller
//    }()
    
    private lazy var weightManagerVC: UIViewController = {
        return buildNavigationController(WeightHistoryViewControllerBuilder.build(),
                                         title: "Трекер веса",
                                         icon: R.image.weightIcon(),
                                         tag: 3)
    }()
    
    private lazy var profileVC: UIViewController = {
        return buildNavigationController(ProfileViewController(),
                                         title: "Профиль",
                                         icon: R.image.profileIcon(),
                                         tag: 4)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setViewControllers([
            waterManagerVC,
            articlesVC,
            weightManagerVC,
            profileVC], animated: true)
    }
    
    // MARK: - TabBar configure
    
    private func configureTabBar() {
        tabBar.addSubview(divider)
        tabBar.backgroundColor = .clear
    }
    
    private lazy var divider: UIView = {
        let divider = UIView(frame: CGRect(x: divilerMargin,
                                           y: 0,
                                           width: tabBar.frame.width - divilerMargin * 2,
                                           height: 1))
        divider.backgroundColor = UIColor.lightGray
        return divider
    }()
    
    // MARK: - Private
    
    private func buildNavigationController(_ controller: UIViewController,
                                           title: String,
                                           icon: UIImage?,
                                           tag: Int) -> UINavigationController {
        controller.title = title
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: tag)
        navigationController.tabBarItem.imageInsets = tabBarItemInsets
        return navigationController
    }

}

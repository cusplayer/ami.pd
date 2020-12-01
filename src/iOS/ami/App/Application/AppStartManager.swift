//
//  Start.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager
import DesignKit

final class AppStartManager {
    
    var window: UIWindow?
    
    init(with window: UIWindow?) {
        if let window = window {
            self.window = window
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        }
    }
    
    static func setupWindow(for scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = scene
        if let accessToken = TokenManager.accessToken {
            print(accessToken)
            window.rootViewController = MainViewController()
        } else {
            window.rootViewController = RegisterViewControllerBuilder.build()
        }
        window.makeKeyAndVisible()
        return window
    }
    
    static func setupAppereance() {
        configureNavBar()
        configureTabBar()
        configureLoaderView()
    }
        
    private static func configureNavBar() {
//         Sets background to a blank/empty image
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .white
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        guard let color = R.color.bcb4(),
            let font = R.font.bloggerSansMedium(size: 24) else { fatalError() }
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: color,
                                                            .font: font]
    }
    
    private static func configureLoaderView() {
        LoaderView.instance.frameSize = 75
        LoaderView.instance.cornerRadius = 15
    }
    
    private static func configureTabBar() {
        UITabBar.appearance().borderWidth = 0.5
        UITabBar.appearance().borderColor = .clear
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().unselectedItemTintColor = R.color.e9765B()
        UITabBar.appearance().tintColor = R.color.bcb4()
    }
    
}

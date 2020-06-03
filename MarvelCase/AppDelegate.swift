//
//  AppDelegate.swift
//  MarvelCase
//
//  Created by Oguz on 2.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CharacterListBuilder().buildWithNavigation(fav: FavoriteListViewModel(), data: CharacterListViewModel())
        window?.makeKeyAndVisible()
        configureGeneralAppearance()
        return true
    }
    
    func configureGeneralAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().shadowImage = UIColor.lightGray.as1ptImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 0.1900647283, green: 0.1900647283, blue: 0.1900647283, alpha: 1)
      //  UITableViewCell.appearance().selectedBackgroundView = selectedView
    }
}


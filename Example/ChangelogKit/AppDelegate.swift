//
//  AppDelegate.swift
//  ChangelogKit
//
//  Created by davidseek on 04/28/2021.
//  Copyright (c) 2021 davidseek. All rights reserved.
//

import UIKit
import ChangelogKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ChangelogKit.changelogURL = "http://changelogdemo.davidseek.md2site.com/"
        return true
    }
}


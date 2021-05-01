//
//  ViewController.swift
//  ChangelogKit
//
//  Created by davidseek on 04/28/2021.
//  Copyright (c) 2021 davidseek. All rights reserved.
//

import UIKit
import ChangelogKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// Presents a banner for every new version
        /// Important: You need to make sure to update the 
        /// `AppVersion` before running. Otherwise nothing will show.
        // ChangelogKit.ready(on: self) <---- Uncomment me

        /// Shows the changelog regardless of user preference
        /// This API makes the most sense as part of a Settings screen
        /// You could have an entry like `Show Changelog` and then call this as action.
        ChangelogKit.presentChangelog(on: self)
    }
}


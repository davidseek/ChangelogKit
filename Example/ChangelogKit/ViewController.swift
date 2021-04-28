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
        ChangelogKit.ready(on: self, useForce: true)
    }
}


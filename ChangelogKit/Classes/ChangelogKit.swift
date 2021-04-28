//
//  ChangelogKit.swift
//  ChangelogKit
//
//  Created by David Seek on 3/13/21.
//

import Foundation
import UIKit
import SafariServices

enum Constants {
    static let bundleVersion = "CFBundleShortVersionString"
    static let defaultsVersionKey = "CHANGELOGKIT::VERSION::"
    static let defaultsSkipKey = "CHANGELOGKIT::INITIAL::INSTALL"
    static let viewIdentifier = "BannerView"
    static let bannerText = "You are now using the latest update!"
    static let buttonInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
}

// Action Enum for you internal logging
enum ChangelogKitAction {
    case didSelectDismiss
    case didSelectShowLog
}

public class ChangelogKit {
    
    private static let defaults = UserDefaults.standard
    private static let banner = BannerView(
        text: Constants.bannerText,
        onAction: bannerViewActionHandler)
    
    private static var currentVersion: String?
    private static var controller: UIViewController?
    public static var changelogURL: String! {
        didSet {
            Log.error("Did initialize ChangelogKit with \(changelogURL ?? "nil")")
        }
    }


    /// Function to either trigger a banner to welcome the user to a new version,
    /// or directly show the changelog if using force
    /// - Parameters:
    ///   - controller: The controller to present on
    ///   - forced: If using force, it will show the changelog without the banner.
    public static func ready(on controller: UIViewController, useForce forced: Bool) {
        Log.info("ChangelogKit ready useForce \(forced)")
        guard let currentVersion = getAppVersion() else {
            Log.error("Invalid app version at \(#function). Interrupting execution")
            return
        }

        self.controller = controller
        self.currentVersion = currentVersion

        let defaultsKey = Constants.defaultsVersionKey + currentVersion
        Log.info("Checking for \(defaultsKey)")
        guard !defaults.bool(forKey: defaultsKey) else {
            Log.info("Has seen version \(currentVersion) before")
            return
        }
        
        Log.info("Has not seen version \(currentVersion) yet")
        

        
        guard !skipVersion(currentVersion) else {
            return
        }

        if forced {
            presentChangelog()
        } else {
            presentBanner(on: controller)
        }
    }
    
    // MARK: - Private
    
    private static func presentBanner(on controller: UIViewController) {
        
        DispatchQueue.main.async {
            controller.view.addSubview(banner)
            controller.view.bringSubviewToFront(banner)
        }
        
        Log.info("Did display banner")
        self.controller = controller
    }
    
    private static func bannerViewActionHandler(action: BannerViewAction) {
        
        Log.info("Did receive action: \(action)")
        
        UIView.animate(withDuration: 0.3) {
            banner.alpha = 0
        } completion: { _ in
            banner.removeFromSuperview()
            Log.info("Did remove banner")
            setVersionSeen()
        }
        
        switch action {
        case .didPressActionButton:
            presentChangelog()
        default: break
        }
    }
    
    private static func presentChangelog() {
        guard let url = URL(string: changelogURL) else {
            Log.error("Invalid url at \(#function). Interrupting execution")
            return
        }

        let webController = WebViewController(url: url)

        if #available(iOS 13, *) {
            webController.modalPresentationStyle = .automatic
        } else {
            webController.modalPresentationStyle = .overFullScreen
        }

        controller?.present(webController, animated: true)
    }
    
    private static func setVersionSeen() {
        
        guard let version = currentVersion else {
            Log.error("Version invalid at \(#function). Interrupting execution")
            return
        }
        
        let defaultsKey = Constants.defaultsVersionKey + version
        Log.info("Setting defaults for: \(defaultsKey)")
        defaults.set(true, forKey: defaultsKey)
        Log.info("Did set defaults for: \(defaultsKey)")
    }
    
    private static func getAppVersion() -> String? {
        let appVersion = Bundle.main.infoDictionary?[Constants.bundleVersion] as? String
        Log.info("appVersion: \(appVersion ?? "")")
        return appVersion
    }
    
    /// Function meant to prevent the upgrade banner from being visible for new users.
    /// For new downloads, every current version is an unseen version.
    /// - Parameter version: Current Application Version.
    /// - Returns: Boolean indicating whether or not execution is desired.
    private static func skipVersion(_ version: String) -> Bool {
        let isNewUser = defaults.bool(forKey: Constants.defaultsSkipKey)
        let skipDesired = !isNewUser
        Log.info("Skip desired: \(skipDesired)")
        
        if skipDesired {
            setVersionSeen()
            setSkipPerformed()
        }
        
        return skipDesired
    }
    
    /// Companion for `skipVersion`
    /// Sets `Constants.defaultsSkipKey` to true.
    private static func setSkipPerformed(){
        let defaultsKey = Constants.defaultsSkipKey
        Log.info("Setting defaults for: \(defaultsKey)")
        defaults.set(true, forKey: defaultsKey)
        Log.info("Did set defaults for: \(defaultsKey)")
    }
}

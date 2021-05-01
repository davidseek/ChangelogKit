//
//  ChangelogKit.swift
//  ChangelogKit
//
//  Created by David Seek on 3/13/21.
//

import Foundation
import UIKit
import SafariServices

private enum Constants {
    static let bundleVersion = "CFBundleShortVersionString"
    static let defaultsVersionKey = "CHANGELOGKIT::VERSION::"
    static let defaultsSkipKey = "CHANGELOGKIT::INITIAL::INSTALL"
    static let viewIdentifier = "BannerView"
    static let bannerText = "You are now using the latest update!"
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
    public static func ready(on controller: UIViewController, useForce forced: Bool = false) {
        Log.info("ChangelogKit ready useForce \(forced)")
        /// We need the current app version to check if the user has seen this version already
        guard let currentVersion = getAppVersion() else {
            Log.error("Invalid app version at \(#function). Interrupting execution")
            return
        }
        /// We need the references for the controller and the version
        self.controller = controller
        self.currentVersion = currentVersion
        /// The defaultsKey is a combination of a UUID,
        /// uniquely identifying the application,
        /// as well as the current app version.
        let defaultsKey = Constants.defaultsVersionKey + currentVersion
        Log.info("Checking for \(defaultsKey)")
        /// We're checking if this app version has been seen already
        /// If so we simply interrupt the execution
        guard !defaults.bool(forKey: defaultsKey) else {
            Log.info("Has seen version \(currentVersion) before")
            return
        }
        Log.info("Has not seen version \(currentVersion) yet")
        /// Next we need to determine if we should skip the execution.
        /// The point of this step is to make sure, that new users,
        /// aka users who have just downloaded the app,
        /// don't see the "Welcome to the new version" banner.
        guard !skipVersion(currentVersion) else {
            return
        }
        /// Lastly we either show the banner, or the Changelog
        if forced {
            presentChangelog(on: controller)
            setVersionSeen()
        } else {
            presentBanner(on: controller)
        }
    }

    /// Presents the WebView controller using the `changelogURL`
    /// - Parameter controller: ViewController to present on
    public static func presentChangelog(on controller: UIViewController?) {
        /// Need to make sure the URL is set
        /// We might want to use assert here, in theory
        /// But this feature shouldn't be a reason for apps to fail
        guard let url = URL(string: changelogURL) else {
            Log.error("Invalid url at \(#function). Interrupting execution")
            return
        }
        /// Initiate the WebView controller
        let webController = WebViewController(url: url)
        /// Set the presentation style depending the OS
        if #available(iOS 13, *) {
            webController.modalPresentationStyle = .automatic
        } else {
            webController.modalPresentationStyle = .overFullScreen
        }
        /// And present the controller
        controller?.present(webController, animated: true)
    }
    
    // MARK: - Private

    /// Function to present the banner visually
    /// The banner gives the user information that they're on a new version
    /// The banner furthermore proves the actions:
    /// - `Close` -> closes the banner without further action
    /// - `Action` -> designed to open the Changelog modal controller
    /// - Parameter controller: The controller to present the modal on
    private static func presentBanner(on controller: UIViewController) {
        DispatchQueue.main.async {
            controller.view.addSubview(banner)
            controller.view.bringSubview(toFront: banner)
        }
        Log.info("Did display banner")
        self.controller = controller
    }

    /// The action handler for the buttons in the banner view
    /// - Parameter action: The action the user took
    private static func bannerViewActionHandler(action: BannerViewAction) {
        Log.info("Did receive action: \(action)")
        /// First thing we want to do, is to remove the banner visually
        UIView.animate(withDuration: 0.3) {
            banner.alpha = 0
        } completion: { _ in
            /// Once invisible we want to remove it
            banner.removeFromSuperview()
            Log.info("Did remove banner")
            /// Lastly we want to set this version as to be seen
            /// to avoid showing the banner next cold start again
            setVersionSeen()
        }

        /// Now we take care of the actual action
        switch action {
        /// As of right now, the only action important is the `Action Button`
        /// The `Close Button` doest not trigger any dedicated action.
        case .didPressActionButton:
            presentChangelog(on: controller)
        default: break
        }
    }

    /// Function that sets the current app version to the user defaults
    /// This enables us to NOT present the banner/changelog next time
    /// the user starts the app with the same version
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

    /// Helper function that return the current App version
    /// This version is then used to determine if the user has already seen this version
    /// - Returns: The `AppVersion` as present in the bundle
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
        /// Firsty we want to make sure, that the user is not a new user.
        let isNewUser = defaults.bool(forKey: Constants.defaultsSkipKey)
        /// If he's a new user, we want to skip
        let skipDesired = !isNewUser
        Log.info("Skip desired: \(skipDesired)")
        if skipDesired {
            /// Setting the intial configuration for new users
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

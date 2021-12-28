//
//  WebViewController.swift
//  ChangelogKit
//
//  Created by David Seek on 3/13/21.
//

import UIKit
import WebKit

private enum Constants {
    private static let webKit = "document.documentElement.style.webkit"
    public static let nibName = "WebViewController"
    public static var disableSelection = "\(webKit)UserSelect='none';"
    public static var disableCallout = "\(webKit)TouchCallout='none';"
}

class WebViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var theNavigationBar: UINavigationBar!
    @IBOutlet weak var theNavigationItem: UINavigationItem!

    private let url: URL
    private let theme: ChangelogKitTheme
    
    private lazy var webView: WKWebView = {
        let config = getConfig()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.contentMode = .scaleToFill
        webView.scrollView.delegate = webViewScrollViewDelegate.shared
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }()
    
    init(url: URL, theme: ChangelogKitTheme) {
        self.url = url
        self.theme = theme
        super.init(nibName: Constants.nibName, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = theme.backgroundColor
        webViewContainer.backgroundColor = theme.backgroundColor
        
        setNavigationBar()
        setWebView()
        loadChangelog()
        resetCache()
    }
    
    // MARK: - Public
    
    @objc func doneTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Private

    /// Function to set a `done button` at the right side of the navigation header
    private func setNavigationBar() {
        theNavigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped))

        theNavigationBar.setBackgroundImage(UIImage(), for: .default)
        theNavigationBar.shadowImage = UIImage()
        theNavigationBar.isTranslucent = true
        theNavigationBar.tintColor = theme.navigationBarTintColor
    }

    /// Function to bootstrap the `WKWebView`
    private func setWebView() {
        webViewContainer.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        webView.navigationDelegate = self
    }

    /// Loads the changelog into the `WKWebView`
    private func loadChangelog() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let request = URLRequest(url: strongSelf.url)
            strongSelf.webView.load(request)
        }
    }

    /// We're resetting the local `WKWebsiteDataStore` cache
    /// to assure that we will always present the latest
    /// and most updated Changelog, instead of a cached and outdated version
    private func resetCache() {
        /// Remove all old cookies
        HTTPCookieStorage.shared.removeCookies(since: Date())
        Log.info("All cookies deleted")
        /// We want to remove all website data
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        /// We fetch all existing records
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: types,
            completionHandler: resetRecords)
    }

    /// Function to remove the data of `WKWebsiteDataRecords`
    /// - Parameter record: The `WKWebsiteDataRecords`
    private func resetRecords(_ records: [WKWebsiteDataRecord]) {
        records.forEach(resetRecord)
    }

    /// Function to remove the data of a `WKWebsiteDataRecord`
    /// - Parameter record: The `WKWebsiteDataRecord`
    private func resetRecord(_ record: WKWebsiteDataRecord) {
        WKWebsiteDataStore
            .default()
            .removeData(
                ofTypes: record.dataTypes,
                for: [record],
                completionHandler: {})
        Log.info("Record \(record) deleted")
    }

    /// Function to create a `WKWebViewConfiguration`
    /// - Returns: The `WKWebViewConfiguration`
    private func getConfig() -> WKWebViewConfiguration {
        /// Get the `WKUserContentController`
        let controller = getController()
        /// Initiate the config and attach the controller as user content
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        return config
    }

    /// Function to create a customized `WKUserContentController`
    /// - Returns: The `WKUserContentController`
    private func getController() -> WKUserContentController {
        /// Get an instance of a WebKit controller
        let controller = WKUserContentController()
        /// Deactivate selection and callout by adding user scripts
        controller.addUserScript(getScript(source: Constants.disableSelection))
        controller.addUserScript(getScript(source: Constants.disableCallout))
        return controller
    }

    /// Convenience function to get a `WKUserScript` from a string
    /// - Parameter source: The desired string
    /// - Returns: Returns a script to be embedded into the `WKUserContentController`
    private func getScript(source: String) -> WKUserScript {
        return WKUserScript(
            source: source,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true)
    }
}

/// https://gist.github.com/maxcampolo/bdcaa7cf3bd3425727d986cc5538acda
class webViewScrollViewDelegate: NSObject, UIScrollViewDelegate {

    // MARK: - Shared delegate
    static var shared = webViewScrollViewDelegate()

    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, 
                decidePolicyFor navigationAction: WKNavigationAction,
                decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        decisionHandler(.allow)
    }
}

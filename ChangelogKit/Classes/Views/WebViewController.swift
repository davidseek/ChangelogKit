//
//  WebViewController.swift
//  ChangelogKit
//
//  Created by David Seek on 3/13/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var theNavigationItem: UINavigationItem!

    private let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
    private let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"
    private let url: URL
    
    private lazy var webView: WKWebView = {
        let config = getConfig()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.contentMode = .scaleToFill
        webView.scrollView.delegate = webViewScrollViewDelegate.shared
        return webView
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: "WebViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theNavigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped))
        
        setWebView()
        loadChangelog()
        resetCache()
    }
    
    // MARK: - Public
    
    @objc func doneTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Private
    
    private func setWebView() {
        webViewContainer.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
    }
    
    private func loadChangelog() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.webView.load(URLRequest(url: strongSelf.url))
        }
    }
    
    private func resetCache() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        Log.info("All cookies deleted")
                
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: types) { records in
            
            records.forEach { record in
                
                WKWebsiteDataStore
                    .default()
                    .removeData(
                        ofTypes: record.dataTypes,
                        for: [record],
                        completionHandler: {})
                
                Log.info("Record \(record) deleted")
            }
        }
    }
    
    private func getConfig() -> WKWebViewConfiguration {
        let controller = getController()
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        return config
    }
    
    private func getController() -> WKUserContentController {
        
        let disableSelectionScript = getScript(source: disableSelectionScriptString)
        let disableCalloutScript = getScript(source: disableCalloutScriptString)
        
        let controller = WKUserContentController()

        controller.addUserScript(disableSelectionScript)
        controller.addUserScript(disableCalloutScript)
        
        return controller
    }
    
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

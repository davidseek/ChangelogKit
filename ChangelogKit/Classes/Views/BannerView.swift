//
//  BannerView.swift
//  ChangelogKit
//
//  Created by David Seek on 3/13/21.
//

import UIKit

/// Just needed to point to current bundle
class BundleCatch {}

private enum Constants {
    static let buttonInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}

enum BannerViewAction {
    case didPressDismissButton
    case didPressActionButton
}

class BannerView: UIView, Nib {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    private var actionHandler: ((BannerViewAction) -> Void)?
    
    init(text: String, onAction: @escaping (BannerViewAction) -> Void) {
        actionHandler = onAction
        super.init(frame: .nib)
        bootstrap(text)
    }

    // Not supported
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public
    
    @IBAction func didPressDismissButton(_ sender: Any) {
        actionHandler?(.didPressDismissButton)
    }
    
    @IBAction func didPressActionButton(_ sender: Any) {
        actionHandler?(.didPressActionButton)
    }
    
    // MARK: - Private
    
    private func bootstrap(_ text: String) {
        register()
        versionLabel.text = text
        
        dismissButton.backgroundColor = .white
        dismissButton.setTitleColor(.systemGreen, for: .normal)
        dismissButton.titleEdgeInsets = Constants.buttonInsets
        dismissButton.layer.cornerRadius = 16
        
        actionButton.backgroundColor = .white
        actionButton.setTitleColor(.systemGreen, for: .normal)
        actionButton.titleEdgeInsets = Constants.buttonInsets
        actionButton.layer.cornerRadius = 16
    }
}

/// Convenience extension for the size of the Banner
extension CGRect {
    public static var nib: CGRect {
        let screen = UIScreen.main.bounds
        return CGRect(x: 0, y: 0, width: screen.width, height: screen.height * 0.2)
    }
}

/// Convenience protocol to init a UIView
protocol Nib {
    func register()
}

/// Convenience extension to init a UIView
extension Nib where Self : UIView {

    func register() {

        /// Get the description components
        let components = type(of: self)
            .description()
            .components(separatedBy: ".")

        /// Get the last element, that should be the nib name
        guard let nibName = components.last else {
            Log.error("Can't find NIB's name")
            return
        }

        /// Get the current bundle using the `BundleCatch`
        let bundle = Bundle(for: type(of: self))
        /// Load all nimbs with the desired name
        let views = bundle.loadNibNamed(nibName, owner: self, options: nil)

        /// Lastly we need to get the first Element
        guard let view = views?.first as? UIView else {
            Log.error("Can't find NIB in Bundle")
            return
        }

        view.frame = bounds
        addSubview(view)
    }
}

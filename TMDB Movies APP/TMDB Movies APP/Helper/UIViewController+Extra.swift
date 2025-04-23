

import UIKit

extension UIViewController {
    private static var activityIndicator: UIActivityIndicatorView?

    func showLoadingIndicator() {
        if UIViewController.activityIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = view.center
            indicator.color = .black
            indicator.hidesWhenStopped = true
            indicator.startAnimating()
            view.addSubview(indicator)
            UIViewController.activityIndicator = indicator
        }
    }

    func hideLoadingIndicator() {
        UIViewController.activityIndicator?.stopAnimating()
        UIViewController.activityIndicator?.removeFromSuperview()
        UIViewController.activityIndicator = nil
    }
}

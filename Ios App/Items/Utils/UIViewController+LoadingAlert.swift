//
//  UIViewController+LoadingAlert.swift
//  Items
//
//  Created by Mike Shevelinsky on 02.02.2021.
//

import UIKit

extension UIViewController {
    
    var loadingAlert: UIAlertController {
        let alert = UIAlertController(title: nil, message: "Loading", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        
        return alert
    }
    
    func presentLoadingAlert(completion: (() -> Void)? = nil) {
        if let _ = self.presentedViewController {
            return
        } else {
            let alert = loadingAlert
            present(alert, animated: true, completion: completion)
        }
    }
    
    func dismissLoadingAlert(completion: (() -> Void)? = nil) {
        guard let _ = self.presentedViewController else { return }
        dismiss(animated: true) {
            self.dismiss(animated: true, completion: {
                completion?()
            })
        }
    }
}

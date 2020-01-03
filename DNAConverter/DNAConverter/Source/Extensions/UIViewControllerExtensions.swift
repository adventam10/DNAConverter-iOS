//
//  UIViewControllerExtensions.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/03.
//  Copyright © 2020 am10. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil,
                   message: String,
                   buttonTitle: String = "OK",
                   buttonAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonTitle,
                                   style: .default,
                                   handler:
            {
                (action: UIAlertAction!) -> Void in
                buttonAction?()
        })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

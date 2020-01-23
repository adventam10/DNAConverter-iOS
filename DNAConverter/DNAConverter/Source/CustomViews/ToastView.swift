//
//  ToastView.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/23.
//  Copyright © 2020 am10. All rights reserved.
//

import UIKit

final class ToastView: UIView {

    @IBOutlet private weak var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.alpha = 0.0
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

    public func showMessage(_ message: String?) {
        messageLabel.text = message
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: [.curveEaseOut], animations: { [weak self] in
            self?.alpha = 1.0
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.3, delay: 1.0,
                           options: [.curveEaseIn], animations: { [weak self] in
                self?.alpha = 0.0
            })
        }
    }
}

//
//  PlaceHolderTextView.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/03.
//  Copyright © 2020 am10. All rights reserved.
//

import UIKit

@IBDesignable class PlaceHolderTextView: UITextView {
    @IBInspectable var placeHolder: String = "" {
        didSet {
            placeHolderLabel.text = placeHolder
            placeHolderLabel.sizeToFit()
        }
    }

    private lazy var placeHolderLabel = UILabel(frame: CGRect(x: 6.0,
                                                              y: 6.0,
                                                              width: 0.0,
                                                              height: 0.0))
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configurePlaceHolder()
        changeVisiblePlaceHolder()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }

    private func configurePlaceHolder() {
        placeHolderLabel.lineBreakMode = .byWordWrapping
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.font = self.font
        placeHolderLabel.textColor = UIColor.systemGray2
        placeHolderLabel.backgroundColor = .clear
        addSubview(placeHolderLabel)
    }

    func changeVisiblePlaceHolder() {
        if placeHolder.isEmpty || !text.isEmpty {
            placeHolderLabel.alpha = 0.0
        } else {
            placeHolderLabel.alpha = 1.0
        }
    }

    @objc private func textChanged(notification: NSNotification?) {
        changeVisiblePlaceHolder()
    }
}

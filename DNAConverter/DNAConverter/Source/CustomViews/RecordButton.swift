//
//  RecordButton.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/11.
//  Copyright © 2020 am10. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    enum RecordState {
        case enable(isRecording: Bool)
        case disable
    }
    var recordState: RecordState = .disable {
        didSet {
            switch recordState {
            case .enable(let isRecording):
                self.isEnabled = true
                self.alpha = 1.0
                self.tintColor = isRecording ? .white : .systemBlue
                self.backgroundColor = isRecording ? .systemBlue : .clear
            case .disable:
                self.isEnabled = false
                self.alpha = 0.7
                self.tintColor = .gray
                self.backgroundColor = .clear
            }
        }
    }
}

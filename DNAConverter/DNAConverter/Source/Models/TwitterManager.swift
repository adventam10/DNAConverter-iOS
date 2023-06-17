//
//  TwitterManager.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/17.
//  Copyright © 2023 am10. All rights reserved.
//

import Foundation
import UIKit

struct TwitterManager {

    private let baseURL = "https://twitter.com/intent/tweet"
    private var hashTag: String {
        return "&hashtags=" + NSLocalizedString("hash_tag", comment: "").urlEncoded!
    }

    func tweet(text: String) -> Bool {
        guard let encodedText = text.urlEncoded,
              let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText + hashTag)") else {
            return false
        }
        if UIApplication.shared.canOpenURL(URL(string: baseURL)!) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
}

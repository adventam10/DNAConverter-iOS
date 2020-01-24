//
//  FoundationExtensions.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/24.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation

extension Bundle {
    var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

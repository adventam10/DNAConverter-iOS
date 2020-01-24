//
//  ArrayExtensions.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/24.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//
//  FileExporter.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/17.
//  Copyright © 2023 am10. All rights reserved.
//

import Foundation

struct FileExporter {

    private var dateFormatter: DateFormatter = {
       var df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyyMMddHHmmss"
        return df
    }()

    func export(_ text: String?, directoryPath: String = NSHomeDirectory() + "/Documents") -> Bool {
        guard let text = text,
            text.isEmpty == false else {
            return false
        }
        let fileName = dateFormatter.string(from: Date()) + ".txt"
        let fileURL = URL(fileURLWithPath: directoryPath + "/" + fileName)
        do {
            try text.data(using: .utf8)?.write(to: fileURL)
        } catch {
            return false
        }
        return true
    }
}

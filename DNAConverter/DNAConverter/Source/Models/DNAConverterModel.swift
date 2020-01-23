//
//  DNAConverterModel.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/03.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation

enum DNAConvertError: Error {
    case empty
    case invalid
    var text: String {
        return NSLocalizedString("error_message", comment: "")
    }
}

final class DNAConverterModel {
    var twitterURL: URL? {
        if isEmptyText(convertedText) {
            return nil
        }
        if let encodedText = convertedText!.urlEncoded,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText + hashTag)") {
            return url
        }
        return nil
    }
    var hashTag: String {
        return "&hashtags=" + NSLocalizedString("hash_tag", comment: "").urlEncoded!
    }
    var originalText: String?
    var convertedText: String?

    private let dnaHexValues: [String: String] =
        ["AA": "0", "AT": "1", "AC": "2", "AG": "3",
         "TA": "4", "TT": "5", "TC": "6", "TG": "7",
         "CA": "8", "CT": "9", "CC": "a", "CG": "b",
         "GA": "c", "GT": "d", "GC": "e", "GG": "f"]
    private var dateFormatter: DateFormatter = {
       var df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyyMMddHHmmss"
        return df
    }()

    func convertToDNA(_ text: String?) -> Result<String, DNAConvertError> {
        if isEmptyText(text) {
            return .failure(.empty)
        }
        var result = text!.hex.lowercased()
        dnaHexValues.forEach { dna, hex in
            result = result.replacingOccurrences(of: hex, with: dna)
        }
        return .success(result)
    }

    func convertToLanguage(_ text: String?) -> Result<String, DNAConvertError> {
        if isEmptyText(text) {
            return .failure(.empty)
        }
        if isInvalidDNA(text) {
            return .failure(.invalid)
        }
        let hex = text!.splitInto(2).compactMap { dnaHexValues[$0] }.joined()
        if hex.isEmpty {
            return .failure(.invalid)
        }
        if let data = hex.hexadecimal,
            let result = String(data: data, encoding: .utf8) {
            return .success(result)
        }
        return .failure(.invalid)
    }

    func isInvalidDNA(_ text: String?) -> Bool {
        if isEmptyText(text) || text!.count % 2 != 0 {
            return true
        }
        return !text!.isOnly(structuredBy: "ATCG")
    }

    func isEmptyText(_ text: String?) -> Bool {
        guard let text = text,
            text.isEmpty == false else {
            return true
        }
        return false
    }

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

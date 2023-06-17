//
//  DNAConverter.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/17.
//  Copyright © 2023 am10. All rights reserved.
//

import Foundation

struct DNAConverter {

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

    private func isEmptyText(_ text: String?) -> Bool {
        guard let text = text,
            text.isEmpty == false else {
            return true
        }
        return false
    }
}

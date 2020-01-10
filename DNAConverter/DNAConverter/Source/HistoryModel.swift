//
//  HistoryModel.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/10.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation

struct HistoryModel {
    private let historyKey = "DNA_History_Key"
    private let maxCount = 10
    private let userDefaults = UserDefaults.standard
    var histories: [String] {
        return userDefaults.array(forKey: historyKey) as? [String] ?? []
    }

    func add(history: String) {
        var saveHistories = histories
        if let index = saveHistories.firstIndex(of: history) {
            saveHistories.remove(at: index)
        }
        if saveHistories.count >= maxCount {
            saveHistories.removeLast()
        }
        saveHistories.insert(history, at: 0)
        userDefaults.set(saveHistories, forKey: historyKey)
        userDefaults.synchronize()
    }
}

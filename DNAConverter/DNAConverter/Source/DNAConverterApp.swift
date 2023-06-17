//
//  DNAConverterApp.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/16.
//  Copyright © 2023 am10. All rights reserved.
//

import SwiftUI

@main
struct DNAConverterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        let appStoreManager = AppStoreManager()
        appStoreManager.checkVersion { result in
            DispatchQueue.main.async {
                if case .success(.shouldUpdate) = result {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let root = windowScene.windows.first?.rootViewController {
                        root.showAlert(message: NSLocalizedString("update_message", comment: ""), buttonAction: {
                            UIApplication.shared.open(appStoreManager.appStoreURL)
                        })
                    }
                }
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

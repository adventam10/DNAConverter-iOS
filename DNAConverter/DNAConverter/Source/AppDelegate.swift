//
//  AppDelegate.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/03.
//  Copyright © 2020 am10. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    #if targetEnvironment(macCatalyst)
    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == UIMenuSystem.main else { return }

        // 初期メニューで不要なものを削除
        builder.remove(menu: .file)
        builder.remove(menu: .format)
        builder.remove(menu: .help)
        builder.remove(menu: .services)
    }
    #endif
}

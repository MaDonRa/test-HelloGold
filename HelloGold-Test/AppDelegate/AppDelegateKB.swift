//
//  AppDelegateKB.swift
//  HelloGold-Test
//
//  Created by Sakkaphong Luaengvilai on 13/5/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

import IQKeyboardManagerSwift

extension AppDelegate {
    
    internal func SetupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}

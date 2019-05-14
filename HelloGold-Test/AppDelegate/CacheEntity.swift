//
//  AppDelegateKB.swift
//  HelloGold-Test
//
//  Created by Sakkaphong Luaengvilai on 13/5/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

import UIKit

internal var Cache = CacheEntity()

class CacheEntity: NSObject {

    private let CacheData : UserDefaults = UserDefaults.standard

    internal func RemoveAllCache() {
        guard let Domain = Bundle.main.bundleIdentifier else { return }
        let FirstTime = Cache.FirstTime
        let Language = Cache.SelectedLanguage
        CacheData.removePersistentDomain(forName: Domain)
        CacheData.synchronize()
        Cache.FirstTime = FirstTime
        Cache.SelectedLanguage = Language
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GotoLoginViewController"), object: nil)
    }
    
    internal var FirstTime:Bool {
        get {
            return CacheData.bool(forKey: "FirstTime")
        }
        set {
            CacheData.Save(Value: newValue, Key: "FirstTime")
        }
    }

    internal var AccessToken:String {
        get {
            return CacheData.string(forKey: "AccessToken") ?? ""
        }
        set {
            CacheData.Save(Value: newValue, Key: "AccessToken")
        }
    }
    
    internal var SelectedLanguage:String {
        get {
            return CacheData.string(forKey: "SelectedLanguage") ?? ""
        }
        set {
            CacheData.Save(Value: newValue, Key: "SelectedLanguage")
        }
    }
}

extension UserDefaults {
    func Save(Value : Any , Key : String) {
        self.set(Value, forKey: Key)
        self.synchronize()
    }
}

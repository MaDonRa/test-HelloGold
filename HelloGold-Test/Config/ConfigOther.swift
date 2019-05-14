//
//  ConfigOther.swift
//  HelloGold-Test
//
//  Created by Sakkaphong Luaengvilai on 13/5/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

import UIKit

struct ConfigOther {
    enum LanguageName {
        case English , Thai
        
        var Language : String {
            switch self {
            case .Thai:
                return "th"
            case .English:
                return "en"
            }
        }
    }
    
    enum Localize : String {
        case All
    }
}



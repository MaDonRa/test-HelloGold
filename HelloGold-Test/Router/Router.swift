//
//  Router.swift
//  HelloGold-Test
//
//  Created by Sakkaphong Luaengvilai on 13/5/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//


import Foundation

struct Router {
    static let Domain : String = "staging.hellogold.com"
    static let BaseUrl : String = "https://" + Router.Domain
    static let SubDomain : String = "/api/"
    static let v2 : String = Router.Domain + "v2/"
    static let v3 : String = Router.Domain + "v3/"
}

struct Path {
    
    static let users : String = "users/"
    static let register : String = Path.users + "register.json"
    
    static let spot_price : String = "spot_price.json"
}


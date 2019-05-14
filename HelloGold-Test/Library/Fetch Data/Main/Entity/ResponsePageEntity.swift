//
//  ResponsePageEntity.swift
//  Aroii
//
//  Created by Sakkaphong Luaengvilai on 7/3/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

struct ResponsePageEntity {
    
    let current_page : Int
    let total_page : Int
    
    init(json : [String : Any]) {
        self.current_page = json["current_page"] as? Int ?? 0
        self.total_page = json["total_page"] as? Int ?? 1
    }
}

//
//  ResponseStatusEntity.swift
//  Aroii
//
//  Created by Sakkaphong Luaengvilai on 8/3/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

struct ResponseStatusEntity {
    
    let ServerStatus : Int
    let Success : Bool
    let Error : [String : Any]
    let ErrorText : String
    
    init(json : [String : Any]) {
        self.ServerStatus = json["status"] as? Int ?? 0
        
        self.Success = json["success"] as? Bool ?? false
        
        self.Error = json["error"] as? [String : Any] ?? [:]
        self.ErrorText = self.Error.map({"\($0.key) : \((($0.value as? [String]) ?? []).isEmpty ? ((($0.value as? String) ?? "") + "\n") : (($0.value as? [String]) ?? []).joined(separator: "\n"))"}).joined(separator: "\n")
    }
}


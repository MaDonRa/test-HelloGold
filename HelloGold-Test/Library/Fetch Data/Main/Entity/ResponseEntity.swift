//
//  ResponseEntity.swift
//  Wala-R2
//
//  Created by Sakkaphong on 1/9/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

struct ResponseEntity {

    let Data : [String : Any]
    let DataString : String
    let DataStringArray : [Any]
    let DataInt : Int
    let DataArray : [[String : Any]]
    let DataBool : Bool

    let Status : ResponseStatusEntity
    
    let Page : ResponsePageEntity
 
    init(json : [String : Any]) {
      
        self.Data = json["data"] as? [String : Any] ?? [:]
        self.DataString = json["data"] as? String ?? ""
        self.DataInt = json["data"] as? Int ?? 0
        self.DataStringArray = json["data"] as? [Any] ?? []
        self.DataArray = json["data"] as? [[String : Any]] ?? []
        self.DataBool = json["data"] as? Bool ?? false
       
        self.Status = ResponseStatusEntity(json: json)
        
        self.Page = ResponsePageEntity(json: json)
    }
}

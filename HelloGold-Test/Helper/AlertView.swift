//
//  AlertView.swift
//  Box24
//
//  Created by Sakkaphong Luaengvilai on 29/6/2561 BE.
//  Copyright © 2561 MaDonRa. All rights reserved.
//

import UIKit


extension UIViewController {
    
    internal func AlertServer(status : Int , error : String) {
        let alert = UIAlertController(title: "Notice", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertServerHaveCallBack(status : Int,error : String , completion:@escaping ()->()) {
        let alert = UIAlertController(title: "Notice", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            return completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertError(title : String = "Error",text : String , ButtonTitle : String = "OK" , completion:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: ButtonTitle, style: .default, handler: { _ in
            return completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertTextSelectCamera(completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Photo", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Albums", style: .default, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertWarning(text : String , completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Notice", message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertText(text : String , completion:@escaping ()->()) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            return completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertExit(completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Notice", message: "You have unsaved data on this page. Do you want to discard changes?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertDeleteData(Title : String ,completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Delete " + Title, message: "Are you sure you want to permanently\nremove this \(Title.lowercased()) from Aroii?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertDeleteItemFormCart(completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Notice", message: "Are you sure you want to remove this order from your cart?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertDeleteThisOrder(completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Notice", message: "Are you sure you want to remove this order ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertDeleteThisBooking(completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Notice", message: "Are you sure you want to remove this booking ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func AlertDeleteItemProfile(Title : String ,completion:@escaping (Bool)->()) {
        let alert = UIAlertController(title: "Notice", message: "Are you sure you want to remove this " + Title + " from your favorite?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            return completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            return completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

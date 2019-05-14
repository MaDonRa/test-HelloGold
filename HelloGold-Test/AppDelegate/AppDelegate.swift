//
//  AppDelegate.swift
//  HelloGold-Test
//
//  Created by Sakkaphong Luaengvilai on 13/5/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HelloGold")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        RegisterLocalNotification()
        
        SetupKeyboard()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    private func RegisterLocalNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckFirstTime), name: NSNotification.Name(rawValue: "GotoLoginViewController") , object: nil)
    }
    
    @objc private func CheckFirstTime() {
        
        if Cache.AccessToken.isEmpty {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterV")
        } else {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardV")
        }
        
        self.window?.makeKeyAndVisible()
    }
}


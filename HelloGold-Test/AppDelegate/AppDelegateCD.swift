//
//  AppDelegateCD.swift
//  HelloGold-Test
//
//  Created by Sakkaphong Luaengvilai on 13/5/2562 BE.
//  Copyright © 2562 Sakkaphong Luaengvilai. All rights reserved.
//

import CoreData

extension AppDelegate {
    
    internal func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


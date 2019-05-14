//
//  ManageData.swift
//  TestCoreData
//
//  Created by Sakkaphong Luaengvilai on 12/1/2560 BE.
//  Copyright © 2560 MaDonRa. All rights reserved.
//

import UIKit
import CoreData

typealias DataRead = DataReader & DataFinder

typealias DataReadWrite = DataReader & DataWriter & DataFinder

typealias DataFullAccess = DataReader & DataWriter & DataFinder & DataRemove

protocol DataReader {
    func read(DB_Name: CoreDataName , OrderBy_ASC : [String : Bool] , completion:@escaping ([NSManagedObject])->())
}

protocol DataFinder {
    func find(DB_Name: CoreDataName , Query : [String : Any] , OrderBy_ASC : [String : Bool] , completion:@escaping ([NSManagedObject])->())
    func GetLastID(DB_Name: CoreDataName , completion:@escaping (NSManagedObject?)->())
}

protocol DataWriter {
    func write(DB_Name: CoreDataName , Data : [String:Any] , completion:@escaping (Bool)->())
    func update(DB_Name: CoreDataName , Key:String , Value : Any , Last_Update : Bool , Data : [String:Any] , completion:@escaping (Bool)->())
}

protocol DataRemove {
    func removeRow(DB_Name: CoreDataName , Key:String , Value:Any , OrderBy_ASC : Bool , completion:@escaping (Bool,NSManagedObject?)->())
    func removeAll(DB_Name: CoreDataName)
}

class FileData: DataReader , DataFinder , DataWriter , DataRemove {
    
    private var ManageData : NSManagedObjectContext? {
        get {
            guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return nil }
            return appDel.persistentContainer.viewContext
        }
    }

    func read(DB_Name: CoreDataName , OrderBy_ASC : [String : Bool] , completion:@escaping ([NSManagedObject])->()) {
        
        guard let Manage = ManageData else { return completion([]) }
        let request = NSFetchRequest<NSManagedObject>(entityName: DB_Name.rawValue)
        
        var sortDescriptors = [NSSortDescriptor]()
        for data in OrderBy_ASC {
            sortDescriptors.append(NSSortDescriptor(key: data.key, ascending: data.value))
        }
        request.sortDescriptors = sortDescriptors
        
        do {
            let results:[NSManagedObject] = try Manage.fetch(request)

            return completion(results)
        } catch {
            print("Error Core Data \(error)")
        }
        print("Can't not load")
        
        return completion([])
    }
    
    func find(DB_Name: CoreDataName , Query : [String : Any] , OrderBy_ASC : [String : Bool] , completion:@escaping ([NSManagedObject])->()) {
        
        guard let Manage = ManageData else { return completion([]) }
        let request = NSFetchRequest<NSManagedObject>(entityName: DB_Name.rawValue)
        
        var QueryArray = [NSPredicate]()
        for data in Query {
            QueryArray.append(NSPredicate(format: "\(data.key) = %@", "\(data.value)"))
        }
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: QueryArray)
        
        var SortDescriptors = [NSSortDescriptor]()
        for data in OrderBy_ASC {
            SortDescriptors.append(NSSortDescriptor(key: data.key, ascending: data.value))
        }
        request.sortDescriptors = SortDescriptors
     
        do {
            let results:[NSManagedObject] = try Manage.fetch(request)
            
            return completion(results)
        } catch {
            print("Error Core Data \(error)")
        }
        print("Can't not load")
        
        return completion([])
    }
    
    func write(DB_Name: CoreDataName , Data : [String:Any] , completion:@escaping (Bool)->()) {
        guard let Manage = self.ManageData else { return }
        let SaveData = NSEntityDescription.insertNewObject(forEntityName: DB_Name.rawValue, into: Manage)

        for data in Data {
            SaveData.setValue(data.value, forKey: data.key)
        }
        SaveData.setValue(Date(), forKey: "last_update_datetime")
        
        do {
            try Manage.save()
            print("Save")
            return completion(true)
        } catch {
            print("Error Save Core Data \(error)")
            return completion(false)
        }
    }
    
    func update(DB_Name: CoreDataName , Key:String , Value : Any , Last_Update : Bool , Data : [String:Any] , completion:@escaping (Bool)->()) {
        guard let Manage = self.ManageData else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: DB_Name.rawValue)
        request.predicate = NSPredicate(format: "\(Key) = %@", "\(Value)")
        do
        {
            let results:[NSManagedObject] = try Manage.fetch(request)

            for data in Data {
                results.last?.setValue(data.value, forKey: data.key)
            }
            if Last_Update {
                results.last?.setValue(Date(), forKey: "last_update_datetime")
            }
            do{
                try Manage.save()
                print("Update")
                return completion(true)
            } catch {
                print(error)
                return completion(false)
            }
        } catch {
            print(error)
            return completion(false)
        }
    }
    
    func GetLastID(DB_Name: CoreDataName , completion:@escaping (NSManagedObject?)->()) {
     
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB_Name.rawValue)
        guard let Manage = ManageData, let results = try? Manage.fetch(request) , let LastID = results as? [NSManagedObject] else { return completion(nil) }
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors

        return completion(LastID.last)
    }
    
    func removeAll(DB_Name: CoreDataName) {
        // Clear DATA
        guard let Manage = ManageData else { return }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DB_Name.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try Manage.execute(deleteRequest)
            try Manage.save()
            print("Remove ALL")
        } catch {
            print ("There was an error \(error)")
        }
    }
    
    func removeRow(DB_Name: CoreDataName , Key:String , Value:Any , OrderBy_ASC : Bool ,  completion:@escaping (Bool,NSManagedObject?)->()) {
   
        guard let Manage = ManageData else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: DB_Name.rawValue)
        request.predicate = NSPredicate(format: "\(Key) = %@", "\(Value)") // Delete Each Row
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: OrderBy_ASC)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        var TempData : NSManagedObject?
        do {
            let results:[NSManagedObject] = try Manage.fetch(request)
            TempData = results.last
            results.forEach {
                Manage.delete($0)
            }
        } catch {
            print("Error Remove Core Data \(error)")
            return completion(false,TempData)
        }
        
        do {
            try Manage.save()
            return completion(true,TempData)
        } catch {
            print(error)
            return completion(false,TempData)
        }
    }
}


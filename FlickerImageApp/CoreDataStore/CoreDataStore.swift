//
//  CoreDataStore.swift
//  TableViewDemo
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStore {
    
    private init() {}
    
    //Returns the current Persistent Container for CoreData
    class func getContext () -> NSManagedObjectContext {
        return CoreDataStore.persistentContainer.viewContext
    }
    
    
    static var persistentContainer: NSPersistentContainer = {
        //The container that holds both data model entities
        let container = NSPersistentContainer(name: "FlickerImageApp")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
                //TODO: - Add Error Handling for Core Data
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    class func saveContext() {
        let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
                print("Data Saved to Context")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: Delete All Data From CoreData
    class func deleteAllData() {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Flicker")
         fetchRequest.returnsObjectsAsFaults = false
         do {
             let results = try CoreDataStore.getContext().fetch(fetchRequest)
             for object in results {
                 guard let objectData = object as? NSManagedObject else {continue}
                 CoreDataStore.getContext().delete(objectData)
             }
            
         } catch let error {
             print("Detele all data in error :", error)
         }
     }
    
    /* Support for GRUD Operations */
    
    // GET / Fetch / Requests
    class func getAllDataFromStore() -> Array<PhotoViewModel> {
        let all = NSFetchRequest<Flicker>(entityName: "Flicker")
        var allData = [PhotoViewModel]()
        
        do {
             let results = try self.getContext().fetch(all)
            
            for data in results {
                allData.append(PhotoViewModel(id: data.id!, owner: data.owner!, secret: data.secret!, server: data.server!, farm: Int(data.farm), title: data.title!, isPublic: Int(data.ispublic), isFriend: Int(data.isfriend), isFamily: Int(data.isfamily), isPrimary: Int(data.is_primary), hasComment: Int(data.has_comment)))
            }
            
        } catch  {
            let nserror = error as NSError
            //TODO: Handle Error
            print(nserror.description)
        }

        return allData
    }
    
}




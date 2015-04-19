//
//  CoreDataStack.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/2/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    class var sharedInstance: CoreDataStack {
        struct Static {
            static let instance: CoreDataStack = CoreDataStack()
        }
        return Static.instance
    }
    
    // MARK: - Core Data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("LeanLog", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
        let storeURL = documentsDirectory.URLByAppendingPathComponent("LeanLog.sqlite")

        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        let storeOptions = [
            NSPersistentStoreUbiquitousContentNameKey:"LeanLogStore",
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: storeOptions, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }

        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        // var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Saving / Deleting / Fetch
    
    func insertNewIdea() -> Idea {
        let newIdea = NSEntityDescription.insertNewObjectForEntityForName("Idea", inManagedObjectContext: managedObjectContext!) as! Idea
        let now = NSDate();
        newIdea.createdAt = now;
        newIdea.updatedAt = now;
        saveContext()
        
        return newIdea
    }
    
    func deleteIdea(idea: Idea) {
        managedObjectContext?.deleteObject(idea)
        saveContext()
    }
    
    func fetchIdeasWithPredicate(predicate: NSPredicate?) -> [Idea]? {
        let fetchRequest = NSFetchRequest(entityName: "Idea")
        
        if let pred = predicate {
            fetchRequest.predicate = predicate
        }
        
        let prioritySortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        let updatedSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [prioritySortDescriptor, updatedSortDescriptor]
        
        return managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Idea]
    }
    
    func insertNewGroup(name: String) -> Group {
        let newGroup = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: managedObjectContext!) as! Group
        newGroup.title = name
        saveContext()
        
        return newGroup
    }
    
    func deleteGroup(group: Group) {
        managedObjectContext?.deleteObject(group)
        saveContext()
    }
    
    func insertNewPurchase(type: String) -> Purchase {
        let newPurchase = NSEntityDescription.insertNewObjectForEntityForName("Purchase", inManagedObjectContext: managedObjectContext!) as! Purchase
        newPurchase.type = type
        saveContext()
        
        return newPurchase
    }
    
    func fetchGroups() -> [Group]? {
        let fetchRequest = NSFetchRequest(entityName: "Group")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Group]
    }
    
    func fetchPurchases() -> [Purchase]? {
        let fetchRequest = NSFetchRequest(entityName: "Purchase")
        
        return managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Purchase]
    }
    
}
//
//  PersistenceServce.swift
//  fireBaseMokr
//
//  Created by александр сибирцев on 10.12.2018.
//  Copyright © 2018 Alexandr Sibirtsev. All rights reserved.
//

import Foundation
import CoreData

class PersistenceServce {
    
    private init() {}
    
    static var contex: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Picturegram")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext () {
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

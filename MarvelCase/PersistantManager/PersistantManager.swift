//
//  PersistantManager.swift
//  MarvelCase
//
//  Created by Oguz on 3.06.2020.
//  Copyright © 2020 Oguz. All rights reserved.
//

import CoreData
import Foundation

final class PersistantManager {

    private init() { }
    static let shared = PersistantManager()


    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CharacterModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T:NSManagedObject>(_ objectType:T.Type) -> [T] {
        let entityName = String(describing: objectType)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchedObject = try context.fetch(fetchRequest) as? [T]
            return fetchedObject ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
}

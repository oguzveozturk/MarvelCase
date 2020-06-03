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
                print("saved")
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func delete<T:NSManagedObject>(_ object:T.Type) -> [T] {
        let entityName = String(describing: object)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let result = try? context.fetch(fetchRequest) as? [T] {
            for object in result {
                context.delete(object)
            }
            return result
        } else {
            return [T]()
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

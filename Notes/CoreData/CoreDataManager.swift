//
//  CoreDataManager.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {//подписать на протокол
    
    private let entityName = "Note"
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    func load(callback: ([NSManagedObject]) -> Void) {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let fetched = try managedObjectContext.fetch(fetchRequest)
            callback(fetched)
        } catch let error as NSError {
            print("Something went wrong while loading the data:\n \(error)\n, \(error.userInfo)")
        }
    }
    
    func save(newNote: NoteModel, callback: (NSManagedObject) -> Void) {
        let entity =
        NSEntityDescription.entity(forEntityName: entityName,
                                   in: managedObjectContext)!
        let note = NSManagedObject(entity: entity,
                                   insertInto: managedObjectContext)
        
        note.create(with: newNote)
        
        do {
            try managedObjectContext.save()
            callback(note)
        } catch let error as NSError {
            print("Something went wrong while saving the data:\n \(error)\n, \(error.userInfo)")
        }
    }
    
    func update(update object: NSManagedObject, with note: NoteModel, callback: (NSManagedObject) -> Void) {
        object.create(with: note)
        
        do {
            try managedObjectContext.save()
            callback(object)
        } catch let error as NSError {
            print("Something went wrong while saving the data:\n \(error)\n, \(error.userInfo)")
        }
    }
    
    func delete(object: NSManagedObject) {
        managedObjectContext.delete(object)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Something went wrong while deleting the data:\n \(error)\n, \(error.userInfo)")
        }
    }
}

//
//  CoreDataManager.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
import UIKit
import CoreData
//MARK: Manages loading, saving, updating and deleting data
class CoreDataManager: CoreDataManagerProtocol {
    
    private let entityName = "Note"
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    func load(callback: ([NSManagedObject]) -> Void) {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let fetched = try managedObjectContext.fetch(fetchRequest)
            callback(fetched)///the closure populates the array of ManagedObjects. See 'NotesViewPresenter' file
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
        
        note.create(with: newNote)///creates a new instance from a NoteModel. See 'Extensions' --> 'ManagedObject'
        
        do {
            try managedObjectContext.save()
            callback(note)///appeding a new object to the array of ManagedObjects
        } catch let error as NSError {
            print("Something went wrong while saving the data:\n \(error)\n, \(error.userInfo)")
        }
    }
    
    func update(update object: NSManagedObject, with note: NoteModel, callback: (NSManagedObject) -> Void) {
        object.create(with: note)
        
        do {
            try managedObjectContext.save()
            callback(object)///updating exisitng value
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

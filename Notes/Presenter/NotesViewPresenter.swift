//
//  NotesViewPresenter.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
import CoreData

protocol NotesViewDelegate: AnyObject {///used to interact with 'NotesListView'
    func reloadTableView()
    func pushDetailView(controller: NoteDetailView)
    func deleteRows(at indexPath: [IndexPath])
    func refreshCounter(count: String)
}

protocol CoreDataManagerProtocol: AnyObject {///used to interact with 'CoreDataManager'
    func load(callback: ([NSManagedObject]) -> Void)
    func save(newNote: NoteModel, callback: (NSManagedObject) -> Void)
    func update(update object: NSManagedObject, with note: NoteModel, callback: (NSManagedObject) -> Void)
    func delete(object: NSManagedObject)
}

class NotesViewPresenter: NotesViewPresenterProtocol, NoteDetailViewPresenterProtocol {
    //singletone pattern is used as presenter is also a data source
    static let shared = NotesViewPresenter(coreDataManager: CoreDataManager())
    
    private let coreDataManager: CoreDataManagerProtocol
    
    private init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    //interacting with delegate
    weak private var notesViewDelegate: NotesViewDelegate?
        
    var dataSource: [NSManagedObject] = [] {
        didSet {
            dataSource.sort {$0.getDate > $1.getDate}
        }
    }
    
    func setListViewDelegate(delegate: NotesViewDelegate?) {
        notesViewDelegate = delegate
    }
    
    func loadData() {
        coreDataManager.load(callback:) { [weak self] notes in
            self?.dataSource = notes
        }
        refreshCounter()
    }
    
    func save(note: NoteModel) {
        coreDataManager.save(newNote: note) { [weak self] note in
            self?.dataSource.append(note)
        }
        notesViewDelegate?.reloadTableView()
        refreshCounter()
    }
    
    func update(at index: Int, with note: NoteModel) {
        coreDataManager.update(update: dataSource[index], with: note) { [weak self] note in
            self?.dataSource[index] = note
        }
        notesViewDelegate?.reloadTableView()
    }
    
    func delete(at indexPath: IndexPath) {
        let object = dataSource.remove(at: indexPath.row)
        coreDataManager.delete(object: object)
        notesViewDelegate?.deleteRows(at: [indexPath])
        refreshCounter()
    }
    
    func didSelectNote(at indexPath: IndexPath) {
        let note = dataSource[indexPath.row]
        let detailView = NoteDetailView(indexPath: indexPath, attributed: note.getAttributed)
        notesViewDelegate?.pushDetailView(controller: detailView)
    }
    
    private func refreshCounter() {
        var count: String
        switch dataSource.count {
        case 0: count = "No Notes"
        case 1: count = "1 Note"
        default: count = "\(dataSource.count) Notes"
        }
        notesViewDelegate?.refreshCounter(count: count)///refresh the notes count in 'NotesListView' toolbar
    }
    
}

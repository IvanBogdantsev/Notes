//
//  NotesViewPresenter.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
import CoreData

protocol NotesViewDelegate: AnyObject {
    func reloadTableView()
    func pushDetailView(controller: NoteDetailView)
    func deleteRows(at indexPath: [IndexPath])
    func refreshCounter(count: String)
}

protocol NotesDetailViewDelegate: AnyObject {}

class NotesViewPresenter: NotesViewPresenterProtocol, NoteDetailViewPresenterProtocol {
    
    static let shared = NotesViewPresenter(coreDataManager: CoreDataManager())
    
    private let coreDataManager: CoreDataManager
    
    weak private var notesViewDelegate: NotesViewDelegate?
    
    weak private var notesDetailViewDelegate: NotesDetailViewDelegate?
    
    var dataSource: [NSManagedObject] = [] {
        didSet {
            dataSource.sort {$0.getDate > $1.getDate}
        }
    }
    
    private init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func setListViewDelegate(delegate: NotesViewDelegate?) {
        notesViewDelegate = delegate
    }
    
    func setDetailViewDelegate(delegate: NotesDetailViewDelegate?) {
        notesDetailViewDelegate = delegate
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
    
    
    func didSelectNote(at index: Int) {
        let note = dataSource[index]
        let detailView = NoteDetailView(index: index, attributed: note.getAttributed)
        notesViewDelegate?.pushDetailView(controller: detailView)
    }
    
    private func refreshCounter() {
        var count: String
        switch dataSource.count {
        case 0: count = "No Notes"
        case 1: count = "1 Note"
        default: count = "\(dataSource.count) Notes"
        }
        notesViewDelegate?.refreshCounter(count: count)
    }
    
}

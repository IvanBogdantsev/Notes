//
//  NotesListView.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import UIKit
import CoreData

protocol NotesViewPresenterProtocol: AnyObject {
    var dataSource: [NSManagedObject] { get }
    func setListViewDelegate(delegate: NotesViewDelegate?)
    func loadData()
    func didSelectNote(at: Int)
    func delete(at indexPath: IndexPath)
}

class NotesListView: UIViewController, NotesViewDelegate {
    
    private let presenter: NotesViewPresenterProtocol = NotesViewPresenter.shared
    
    private let dateConverter = DateConverter()
    
    private let notesTitle = "Notes"
    
    private let reuseIdentifier = "cell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfSetUp()
        setUpTableView()
        setUpToolBar()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func selfSetUp() {
        presenter.setListViewDelegate(delegate: self)
        presenter.loadData()
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        self.title = notesTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    private func setUpTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setUpToolBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addNewNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapAddNoteButton(sender:)))
        let counter = UIBarButtonItem(customView: counterLabel)
        toolbarItems = [spacer, counter, spacer, addNewNote]
        navigationController?.toolbar.tintColor = .systemYellow
        navigationController?.isToolbarHidden = false
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        let note = presenter.dataSource[indexPath.row]
        let date = dateConverter.convert(date: note.getDate)
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.noteConfiguration(title: note.getTitle, subtitle: note.getSubtitle, date: date)
        cell.contentConfiguration = configuration
    }
    
    @objc private func didTapAddNoteButton(sender: UIBarButtonItem?) {
        navigationController?.pushViewController(NoteDetailView(), animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func deleteRows(at indexPath: [IndexPath]) {
        tableView.deleteRows(at: indexPath, with: .left)
    }
    
    func pushDetailView(controller: NoteDetailView) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func refreshCounter(count: String) {
        counterLabel.text = count
        counterLabel.sizeToFit()
    }
    
}

//MARK: DATASOURCE
extension NotesListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        
        configure(cell: &cell, for: indexPath)
        
        return cell
    }
    
}

//MARK: DELEGATE
extension NotesListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectNote(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteNote = UIContextualAction(style: .destructive, title: nil) { _,_,_ in
            self.presenter.delete(at: indexPath)
        }
        
        deleteNote.image = UIImage(systemName: "trash")
        let action = UISwipeActionsConfiguration(actions: [deleteNote])
        
        return action
    }
    
}

//
//  NotesDetailView.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import UIKit

protocol NoteDetailViewPresenterProtocol: AnyObject {///used to interact with presenter
    func save(note: NoteModel)
    func update(at index: Int, with note: NoteModel)
    func delete(at indexPath: IndexPath)
}
//MARK: Text input scene. Manages text layout and some basic saving/updating/deleting logic
class NoteDetailView: UIViewController, UITextViewDelegate {
    //private props
    private let presenter: NoteDetailViewPresenterProtocol = NotesViewPresenter.shared
    
    private let resolver = SavingResolver()
        
    private var indexPath: IndexPath?///nil if new note is being created
    
    private var didEditNote = false
    
    private var isEditingTitle: Bool {///true if user input is being added to the first line of TextView
        get {
            return firstLineRange.contains(textView.selectedRange.upperBound-1)
        }
    }
    
    private var firstLineRange: NSRange {
        get {
            return lines[0].isEmpty ? NSMakeRange(-1, 1) : (textView.text as NSString).range(of: lines[0])
        }
    }
    
    private var lines: [String] {
        get {
            return textView.text.components(separatedBy: .newlines)
        }
    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.typingAttributes = [.font : UIFont.boldSystemFont(ofSize: 30), .foregroundColor : UIColor.label]
        return textView
    }()
    //convenience init used to load existing note. See 'didSelectNote' of presenter
    convenience init(indexPath: IndexPath, attributed: NSAttributedString) {
        self.init()
        self.indexPath = indexPath
        self.textView.attributedText = attributed
    }
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfSetUp()
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard indexPath == nil else { return }
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard didEditNote else { return }
        guard let note = resolver.transformIntoSavableObject(components: lines, attributed: textView.attributedText) else { return }
        saveOrUpdate(note: note)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard didEditNote else { return }
        guard let indexPath = self.indexPath, textView.text.isEmpty else { return }
        presenter.delete(at: indexPath)///deletes note, if note existed and its text was removed
    }
    //configure elements
    private func selfSetUp() {
        textView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    //saveOrUpdate func decides whether to save a new note or update an existing one
    private func saveOrUpdate(note: NoteModel) {
        if let indexPath = self.indexPath {
            presenter.update(at: indexPath.row, with: note)
            return
        }
        presenter.save(note: note)
    }
    //textViewDidChangeSelection func manages text layout - the first line is in bold, others are in regular
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.typingAttributes = isEditingTitle ?
        [.font : UIFont.boldSystemFont(ofSize: 30), .foregroundColor : UIColor.label] :
        [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.label]
        guard !didEditNote else { return }
        didEditNote.toggle()
    }
    
}

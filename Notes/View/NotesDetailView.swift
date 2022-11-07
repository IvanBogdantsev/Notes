//
//  NotesDetailView.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import UIKit

protocol NoteDetailViewPresenterProtocol: AnyObject {
    func setDetailViewDelegate(delegate: NotesDetailViewDelegate?)
    func save(note: NoteModel)
    func update(at index: Int, with note: NoteModel)
    func delete(at indexPath: IndexPath)
}

class NoteDetailView: UIViewController, NotesDetailViewDelegate, UITextViewDelegate {
    
    private let presenter: NoteDetailViewPresenterProtocol = NotesViewPresenter.shared
    
    private let resolver = SavingResolver()
        
    private var index: Int?
    
    private var didEditNote = false
    
    private var isEditingTitle: Bool {
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
    
    convenience init(index: Int, attributed: NSAttributedString) {
        self.init()
        self.index = index
        self.textView.attributedText = attributed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfSetUp()
        setUpConstraints()
    }
    
    private func selfSetUp() {
        presenter.setDetailViewDelegate(delegate: self)
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
    
    private func saveOrUpdate() {
        guard didEditNote else { return }
        guard let note = resolver.transformIntoSavableObject(components: lines, attributed: textView.attributedText) else { return }
        if let index = self.index {
         presenter.update(at: index, with: note)
        }
        presenter.save(note: note)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.typingAttributes = isEditingTitle ?
        [.font : UIFont.boldSystemFont(ofSize: 30), .foregroundColor : UIColor.label] :
        [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.label]
        guard !didEditNote else { return }
        didEditNote.toggle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard index == nil else { return }
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) { //распихать по функциям
        super.viewWillDisappear(animated)
        
        saveOrUpdate()
    }
    
}

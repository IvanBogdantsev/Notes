//
//  ManagedObject.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
import CoreData
//MARK: NSAttributedString extension to give easier acces to entity's attributes
extension NSManagedObject {///refactoring note: creating a specific object such as 'ManagedNote' subclassed from NSManagedObject would be more suitable and futureproof solution
    var getTitle: String {
        get {
            let title = self.value(forKey: Keys.title.rawValue) as? String ?? String()
            return title
        }
    }
    
    var getSubtitle: String {
        get {
            let subtitle = self.value(forKey: Keys.subtitle.rawValue) as? String ?? String()
            return subtitle
        }
    }
    
    var getDate: Date {
        get {
            let date = self.value(forKey: Keys.date.rawValue) as? Date ?? Date()
            return date
        }
    }
    
    var getAttributed: NSAttributedString {
        get {
            let attributedString = self.value(forKey: Keys.attributedString.rawValue) as? NSAttributedString ?? NSAttributedString()
            return attributedString
        }
    }
    
    func create(with note: NoteModel) {
        self.setValuesForKeys([Keys.title.rawValue : note.title,
                               Keys.subtitle.rawValue : note.subTitle,
                               Keys.date.rawValue : note.date,
                               Keys.attributedString.rawValue : note.attributed])
    }
    
}

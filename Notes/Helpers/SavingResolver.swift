//
//  SavingResolver.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
//MARK: Creates a 'NoteModel' instance from 'NotesDetailView' input
struct SavingResolver {
    
    let emptySubtitleFiller = "No additional text"
    
    func transformIntoSavableObject(components: [String], attributed: NSAttributedString) -> NoteModel? {
        let usefulLines = components.map{$0.trimmingCharacters(in: .whitespaces)}.filter{!$0.isEmpty}.prefix(2)
        
        switch usefulLines.count {///useful lines - lines that contain text. Others are filtred above. Useful lines are then used for correct display in a TableViewCell of 'NotesListView'
        case 1: return NoteModel(title: usefulLines[0], subTitle: emptySubtitleFiller, date: Date(), attributed: attributed)
        case 2: return NoteModel(title: usefulLines[0], subTitle: usefulLines[1], date: Date(), attributed: attributed)
        default: return nil
        }
    }
    
}

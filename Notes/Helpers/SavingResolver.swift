//
//  SavingResolver.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation

struct SavingResolver {
    
    let emptySubtitleFiller = "No additional text"
    
    func transformIntoSavableObject(components: [String], attributed: NSAttributedString) -> NoteModel? {
        let usefulLines = components.map{$0.trimmingCharacters(in: .whitespaces)}.filter{!$0.isEmpty}.prefix(2)
        
        switch usefulLines.count {
        case 1: return NoteModel(title: usefulLines[0], subTitle: emptySubtitleFiller, date: Date(), attributed: attributed)
        case 2: return NoteModel(title: usefulLines[0], subTitle: usefulLines[1], date: Date(), attributed: attributed)
        default: return nil
        }
    }
    
}

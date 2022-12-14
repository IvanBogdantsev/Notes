//
//  ValueTransformer.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
//MARK: Transformer for NSAttributedString
@objc(NSAttributedTransformer)
final class NSAttributedTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [NSAttributedString.self]
    }
    
}

//
//  CellConfiguration.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation
import UIKit

extension UIListContentConfiguration {
    
    public mutating func noteConfiguration(title: String, subtitle: String, date: String) {
        self.text = title
        self.secondaryText = "\(date) \(subtitle)"
        self.textProperties.font = UIFont.boldSystemFont(ofSize: 17)
        self.secondaryTextProperties.font = UIFont.systemFont(ofSize: 15)
        self.secondaryTextProperties.color = .systemGray
        self.textProperties.numberOfLines = 1
        self.secondaryTextProperties.numberOfLines = 1
    }
    
}

//
//  PlaylistSectionCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/01/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import Firebase
import Foundation

class DateSectionCell: UITableViewHeaderFooterView {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "DateSectionCell"
        static let height: CGFloat = 32.0
    }
        
    // MARK: IBOutlet
    @IBOutlet weak private var dateLabel: UILabel!

    // MARK: LifeCycle
    func setUp(date: String) {
        dateLabel.text = date
    }
}

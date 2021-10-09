//
//  PlaylistSectionCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/01/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import Firebase
import Foundation

class SectionCell: UITableViewHeaderFooterView {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "SectionCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        static let height: CGFloat = 32.0
    }
        
    // MARK: IBOutlet
    @IBOutlet weak private var descriptionLabel: UILabel!

    // MARK: LifeCycle
    func setUp(desc: String) {
        descriptionLabel.text = desc
    }
}

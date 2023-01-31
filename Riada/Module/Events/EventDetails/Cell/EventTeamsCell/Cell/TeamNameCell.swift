//
//  PlaylistSectionCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/01/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import Firebase
import Foundation

class TeamNameCell: UITableViewHeaderFooterView {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "TeamNameCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        static let height: CGFloat = 48.0
    }
        
    // MARK: IBOutlet
    @IBOutlet weak private var nameLabel: UILabel!

    // MARK: LifeCycle
    func setUp(teamName: String, isEven: Bool) {
        nameLabel.text = teamName.uppercaseFirstLetter
        nameLabel.textAlignment = isEven ? .left : .right
    }
}

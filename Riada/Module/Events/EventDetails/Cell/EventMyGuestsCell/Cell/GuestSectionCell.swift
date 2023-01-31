//
//  PlaylistSectionCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/01/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import Firebase
import Foundation

class GuestSectionCell: UITableViewHeaderFooterView {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "GuestSectionCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        static let height: CGFloat = 84.0
    }
        
    // MARK: IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descLabel: UILabel!

    // MARK: LifeCycle 
    func setUp() {
        titleLabel.text = L10N.event.details.myGuests.title
        descLabel.text = L10N.event.details.myGuests.desc
    }
}

//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class EventTitleCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 68
        static let identifier: String = "EventTitleCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nameLabel: UILabel!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        nameLabel.text = ""
    }
    
    func setUp(title: String) {
        selectionStyle = .none
        nameLabel.text = title.uppercaseFirstLetter
    }
}

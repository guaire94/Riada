//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventDateAndHourCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 84
        static let identifier: String = "EventDateAndHourCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 16
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var hourLabel: UILabel!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp(date: Timestamp) {
        setUpUI()
        dateLabel.text = date.long.uppercaseFirstLetter
        hourLabel.text = date.hour
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
    }
}

//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventInformationsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 120
        static let identifier: String = "EventInformationsCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var descTextView: UITextView!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp(date: Timestamp, desc: String) {
        setUpUI()
        dateLabel.text = date.long + "-" + date.hour
        descTextView.text = desc
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
    }
}

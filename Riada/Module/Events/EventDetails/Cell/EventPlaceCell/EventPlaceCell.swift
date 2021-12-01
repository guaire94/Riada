//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventPlaceCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 107
        static let identifier: String = "EventPlaceCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        nameLabel.text = ""
        addressLabel.text = ""
    }
    
    func setUp(name: String, address: String) {
        setUpUI()
        
        nameLabel.text = name
        addressLabel.text = address
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
    }
}

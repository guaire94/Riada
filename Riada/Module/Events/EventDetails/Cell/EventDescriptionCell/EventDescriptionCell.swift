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

class EventDescriptionCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 60
        static let identifier: String = "EventDescriptionCell"
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
    
    func setUp(desc: String) {
        let prefix = L10N.event.details.about
        let fullDescription = prefix + desc

        let prefixFont = UIFont.bold
        let font = UIFont.body

        let attributedText = NSMutableAttributedString(string: fullDescription,
                                                        attributes: [NSAttributedString.Key.font: font])
        attributedText.addAttribute(NSAttributedString.Key.font,
                                      value: prefixFont,
                                      range: NSRange(location: 0, length: prefix.count))

        nameLabel.attributedText = attributedText
    }
}

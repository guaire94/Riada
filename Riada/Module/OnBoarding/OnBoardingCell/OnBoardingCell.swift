//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class OnBoardingCell: UITableViewCell {
    
    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 63
        static let identifier: String = "OnBoardingCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 15
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var markAsFavoriteImage: UIImageView!
    
    // MARK: - Privates
    var isMark: Bool = false {
        didSet {
            markAsFavoriteImage.image = isMark ? #imageLiteral(resourceName: "starFull") : #imageLiteral(resourceName: "star")
        }
    }

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        selectionStyle = .none
    }
        
    func configure(sport: Sport) {
        nameLabel.text = sport.localizedName
        markAsFavoriteImage.image = #imageLiteral(resourceName: "star")
    }
}

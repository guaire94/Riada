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
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var markAsFavoriteImage: UIImageView!
    
    // MARK: - Privates
    override var isSelected: Bool {
        didSet {
            markAsFavoriteImage.image = isSelected ? #imageLiteral(resourceName: "starFull") : #imageLiteral(resourceName: "star")
        }
    }

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = Constants.contentCornerRadius
        selectionStyle = .none
    }
        
    func configure(sport: Sport) {
        nameLabel.text = sport.localizedName
        markAsFavoriteImage.image = #imageLiteral(resourceName: "star")
    }
}

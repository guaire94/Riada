//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SportCell: UITableViewCell {
    
    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 174
        static let identifier: String = "SportCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
        fileprivate static let nameCornerRadius: CGFloat = 4
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var backgroundImage: UIImageView!
    @IBOutlet weak private var nameView: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var markAsFavoriteButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = Constants.contentCornerRadius
        nameView.layer.cornerRadius = Constants.contentCornerRadius
        markAsFavoriteButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        markAsFavoriteButton.setImage(#imageLiteral(resourceName: "starFull"), for: .selected)
        selectionStyle = .none
    }
        
    func configure(sport: Sport, isFavoriteSport: Bool) {
        nameLabel.text = sport.localizedName
        let storage = Storage.storage().reference(forURL: sport.image)
        backgroundImage.sd_setImage(with: storage)
        markAsFavoriteButton.isSelected = isFavoriteSport
    }
}

private extension SportCell {

    @IBAction func markAsFavoriteToggle(_ sender: Any) {
        //TODO: handle mark as favorite
    }
}

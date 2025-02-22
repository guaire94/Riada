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
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var backgroundImage: UIImageView!
    @IBOutlet weak private var nameView: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var markAsFavoriteButton: UIButton!
    
    // MARK: - IBOutlet
    private var sport: Sport? {
        didSet {
            guard let sport = sport else { return }
            nameLabel.text = sport.localizedName.uppercased()

            if let url = URL(string: sport.image) {
                backgroundImage.sd_setImage(with: url)
            }
        }
    }
    private var isFavoriteSport: Bool = false {
        didSet {
            markAsFavoriteButton.setImage(isFavoriteSport ? #imageLiteral(resourceName: "starFull") : #imageLiteral(resourceName: "star"), for: .normal)
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        nameView.layer.cornerRadius = Constants.nameCornerRadius
        nameView.clipsToBounds = true
        selectionStyle = .none
    }
        
    func configure(sport: Sport, isFavoriteSport: Bool) {
        self.sport = sport
        self.isFavoriteSport = isFavoriteSport
    }
}

// MARK: - IBAction
private extension SportCell {

    @IBAction func markAsFavoriteToggle(_ sender: Any) {
        guard let sport = sport else { return }

        if isFavoriteSport {
            HelperTracking.track(item: .homeRemoveFavoriteSport(sportName: sport.name))
            ManagerUser.shared.removeFavoriteSport(sport: sport)
        } else {
            HelperTracking.track(item: .homeAddFavoriteSport(sportName: sport.name))
            ManagerUser.shared.addFavoriteSport(sport: sport)
        }
        isFavoriteSport = !isFavoriteSport
    }
}

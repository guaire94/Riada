//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class GuestCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 48
        static let identifier: String = "GuestCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        avatar.sd_cancelCurrentImageLoad()
        avatar.image = nil
        nameLabel.text = ""
        statusLabel.text = ""
    }
    
    func setUp(guest: Guest) {
        setUpUI()

        nameLabel.text = guest.guestNickName.uppercaseFirstLetter
        if let guestAvatar = guest.associatedUserAvatar, let url = URL(string: guestAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
        statusLabel.text = guest.participationStatus.desc
        statusLabel.textColor = guest.participationStatus.color
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
    }
}

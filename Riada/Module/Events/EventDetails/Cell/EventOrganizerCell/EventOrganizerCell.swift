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

class EventOrganizerCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 78
        static let identifier: String = "EventOrganizerCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!

    // MARK: - Properties
    var organizer: Organizer? {
        didSet {
            setOrganizer()
        }
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        avatar.sd_cancelCurrentImageLoad()
        avatar.image = nil
        nameLabel.text = ""
    }
    
    func setUp(organizer: Organizer) {
        setUpUI()
        
        self.organizer = organizer
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
    }
    
    private func setOrganizer() {
        nameLabel.text = organizer?.userNickName
        if let userAvatar = organizer?.userAvatar, let url = URL(string: userAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
   }
}

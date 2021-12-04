//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventParticipantCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 78
        static let identifier: String = "EventParticipantCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let goToProfileImage = UIImage(named: "next")
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var statusImageView: UIImageView!
    @IBOutlet weak private var goToProfileImageView: UIImageView!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        avatar.sd_cancelCurrentImageLoad()
        avatar.image = nil
        nameLabel.text = ""
        goToProfileImageView.image = nil
    }
    
    func setUp(participant: Participant) {
        setUpUI()
        if participant.userId == ManagerUser.shared.userId {
            nameLabel.text = String(format: L10N.event.details.currentUserParticipate, arguments: [participant.userNickName])
            goToProfileImageView.image = nil
        } else {
            nameLabel.text = participant.userNickName
            goToProfileImageView.image = Constants.goToProfileImage
        }
        if let userAvatar = participant.userAvatar, let url = URL(string: userAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
        statusImageView.backgroundColor = participant.participationStatus.color
    }
    
    func setUp(guest: Guest) {
        setUpUI()
        
        if guest.associatedUserId == ManagerUser.shared.userId {
            goToProfileImageView.image = nil
        } else {
            goToProfileImageView.image = Constants.goToProfileImage
        }
        nameLabel.text = String(format: L10N.event.details.guestBy, arguments: [guest.guestNickName, guest.associatedUserNickName])

        if let userAvatar = guest.associatedUserAvatar, let url = URL(string: userAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
        statusImageView.backgroundColor = guest.participationStatus.color
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        statusImageView.layer.cornerRadius = statusImageView.frame.height/2
        statusImageView.clipsToBounds = true
    }
}

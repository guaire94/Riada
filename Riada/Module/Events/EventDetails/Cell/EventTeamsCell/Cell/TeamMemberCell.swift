//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class TeamMemberCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 48
        static let identifier: String = "TeamMemberCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        avatar.sd_cancelCurrentImageLoad()
        avatar.image = nil
        nameLabel.text = ""
    }
    
    func setUp(member: TeamMember, isEven: Bool) {
        setUpUI()

        nameLabel.text = member.userNickName.uppercaseFirstLetter
        nameLabel.textAlignment = isEven ? .left : .right

        stackView.removeArrangedSubview(avatar)
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        stackView.insertArrangedSubview(avatar, at: isEven ? 0 : 1)
        stackView.setNeedsLayout()

        if let userAvatar = member.userAvatar, let url = URL(string: userAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
    }
}

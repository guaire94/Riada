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
        static let height: CGFloat = 115
        static let identifier: String = "EventOrganizerCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 16
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var organizedLabel: UILabel!
    @IBOutlet weak private var nbOrganizedLabel: UILabel!
    @IBOutlet weak private var playedLabel: UILabel!
    @IBOutlet weak private var nbPlayedLabel: UILabel!

    // MARK: - Properties
    var organizer: Organizer? {
        didSet {
            setOrganizer()
            fetchNumbers()
        }
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        avatar.sd_cancelCurrentImageLoad()
        avatar.image = nil
        nameLabel.text = ""
        organizedLabel.text = ""
        nbOrganizedLabel.text = ""
        playedLabel.text = ""
        nbPlayedLabel.text = ""
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
        organizedLabel.text = L10N.event.details.nbOrganized
        playedLabel.text = L10N.event.details.nbPlayed
    }
    
    private func setOrganizer() {
        nameLabel.text = organizer?.userNickName.uppercaseFirstLetter
        if let userAvatar = organizer?.userAvatar, let url = URL(string: userAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
   }

    private func fetchNumbers() {
        guard let organizer = organizer else { return }

        ServiceUser.getNbEventOrganized(userId: organizer.userId) { [weak self] nbEventOrganized in
            self?.nbOrganizedLabel.text = "\(nbEventOrganized ?? 0)"
        }

        ServiceUser.getNbEventPlayed(userId: organizer.userId) { [weak self] nbEventPlayed in
            self?.nbPlayedLabel.text = "\(nbEventPlayed ?? 0)"
        }
   }
}

//
//  AgendaCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class RelatedEventCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 130
        static let identifier: String = "RelatedEventCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var placeAddressLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var organizerAvatar: UIImageView!
    @IBOutlet weak private var organizerNameLabel: UILabel!
    @IBOutlet weak private var numberOfPlayerLabel: UILabel!

    // MARK: - Properties
    var isOrganizer: Bool = false
    var event: RelatedEvent? {
        didSet {
            setEvent()
        }
    }
    var organizer: Organizer? {
        didSet {
            organizerNameLabel.text = organizer?.userNickName
            if let userAvatar = organizer?.userAvatar {
                let storage = Storage.storage().reference(forURL: userAvatar)
                organizerAvatar.sd_setImage(with: storage)
            } else {
                organizerAvatar.image = #imageLiteral(resourceName: "avatar")
            }
        }
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpUI()

        titleLabel.text = ""
        placeAddressLabel.text = ""
        organizerAvatar.sd_cancelCurrentImageLoad()
        organizerAvatar.image = nil
        organizerNameLabel.text = ""
        numberOfPlayerLabel.text = ""
    }
    
    func setUp(event: RelatedEvent, isOrganizer: Bool) {
        setUpUI()
        self.isOrganizer = isOrganizer
        self.event = event
    }
    
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        organizerAvatar.layer.cornerRadius = organizerAvatar.frame.height/2
        organizerAvatar.clipsToBounds = true
    }
    
    // MARK: - Private
    private func setEvent() {
        guard let event = event else { return }
        titleLabel.text = event.sportLocalizedName + " - " + event.title
        placeAddressLabel.text = event.placeAddress
        timeLabel.text = event.date.hour
        numberOfPlayerLabel.text = String(format: L10N.event.nbPlayer, arguments: [event.nbPlayer])
        if !isOrganizer {
            syncOrganizer()
        }
   }
    
    private func syncOrganizer() {
        guard let eventId = event?.id else { return }
        ServiceEvent.getEventOrganizer(eventId: eventId) { (organizer) in
            self.organizer = organizer
        }
   }
}

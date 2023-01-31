//
//  AgendaCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 130
        static let identifier: String = "EventCell"
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

    // MARK: - Properties
    var event: Event? {
        didSet {
            setEvent()
        }
    }
    var organizer: Organizer? {
        didSet {
            organizerNameLabel.text = organizer?.userNickName
            if let userAvatar = organizer?.userAvatar, let url = URL(string: userAvatar) {
                organizerAvatar.sd_setImage(with: url)
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
    }
    
    func setUp(event: Event) {
        setUpUI()
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
        titleLabel.text = event.title
        placeAddressLabel.text = event.placeAddress
        timeLabel.text = event.date.hour
        syncOrganizer()
   }
    
    private func syncOrganizer() {
        guard let eventId = event?.id else { return }
        ServiceEvent.getEventOrganizer(eventId: eventId) { (organizer) in
            self.organizer = organizer
        }
   }
}

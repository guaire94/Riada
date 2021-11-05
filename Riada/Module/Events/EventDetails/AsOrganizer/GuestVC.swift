//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit
import Firebase

protocol GuestVCDelegate: class {
    func didUpdateNbAcceptedPlayerFromGuest(nbAcceptedPlayer: Int)
}

class GuestVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "GuestVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
        fileprivate static let goToProfileImage = UIImage(named: "next")
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var statusImageView: UIImageView!
    @IBOutlet weak private var acceptButton: MButton!
    @IBOutlet weak private var refuseButton: MButton!
    @IBOutlet weak private var goToProfileImageView: UIImageView!
    
    // MARK: - Properties
    weak var delegate: GuestVCDelegate?
    var event: Event?
    var guest: Guest?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpGuest()
    }
    
    // MARK: - Privates
    private func setupView() {
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        statusImageView.layer.cornerRadius = statusImageView.frame.height/2
        statusImageView.clipsToBounds = true
        goToProfileImageView.image = nil
    }
    
    func setUpGuest() {
        guard let guest = self.guest else { return }
        nameLabel.text = String(format: L10N.event.details.guestBy, arguments: [guest.guestNickName, guest.associatedUserNickName])

        if guest.associatedUserId == ManagerUser.shared.user?.id {
            goToProfileImageView.image = nil
        } else {
            goToProfileImageView.image = Constants.goToProfileImage
        }
        
        if let userAvatar = guest.associatedUserAvatar {
            let storage = Storage.storage().reference(forURL: userAvatar)
            avatar.sd_setImage(with: storage)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
        statusImageView.backgroundColor = guest.participationStatus.color
    }
}

// MARK: - IBAction
private extension GuestVC {
    
    @IBAction func profileToggle() {
       // TODO: go to profile (which add this guest)
    }
    
    @IBAction func acceptToggle() {
        guard let event = self.event,
              let eventId = event.id,
              let guest = self.guest,
              guest.status != ParticipationStatus.accepted.rawValue else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        ServiceEvent.acceptGuest(eventId: eventId, guest: guest)

        let nbAcceptedPlayer = event.nbAcceptedPlayer+1
        delegate?.didUpdateNbAcceptedPlayerFromGuest(nbAcceptedPlayer: nbAcceptedPlayer)
        ServiceEvent.updateNbAcceptedPlayer(eventId: eventId, nbAcceptedPlayer: nbAcceptedPlayer)

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refuseToggle() {
        guard let event = self.event,
              let eventId = event.id,
              let guest = self.guest,
              guest.status != ParticipationStatus.refused.rawValue else {
            dismiss(animated: true, completion: nil)
            return
        }

        ServiceEvent.refuseGuest(eventId: eventId, guest: guest)
        if guest.status == ParticipationStatus.accepted.rawValue {
            let nbAcceptedPlayer = event.nbAcceptedPlayer-1
            delegate?.didUpdateNbAcceptedPlayerFromGuest(nbAcceptedPlayer: nbAcceptedPlayer)
            ServiceEvent.updateNbAcceptedPlayer(eventId: eventId, nbAcceptedPlayer: nbAcceptedPlayer)
        }
        dismiss(animated: true, completion: nil)
    }
}

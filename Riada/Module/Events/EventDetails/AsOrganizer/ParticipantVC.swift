//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit
import Firebase

protocol ParticipantVCDelegate: AnyObject {
    func didTapOnParticipantProfile(userId: String)
    func didAcceptParticipation(participant: Participant)
}

class ParticipantVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "ParticipantVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var statusImageView: UIImageView!
    @IBOutlet weak private var acceptButton: MButton!
    @IBOutlet weak private var refuseButton: MButton!

    // MARK: - Properties
    weak var delegate: ParticipantVCDelegate?
    var event: Event?
    var participant: Participant?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpParticipant()
    }
    
    // MARK: - Privates
    private func setupView() {
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        statusImageView.layer.cornerRadius = statusImageView.frame.height/2
        statusImageView.clipsToBounds = true
    }
    
    func setUpParticipant() {
        guard let participant = self.participant else { return }
        if participant.userId == ManagerUser.shared.userId {
            nameLabel.text = String(format: L10N.event.details.currentUserParticipate, arguments: [participant.userNickName])
        } else {
            nameLabel.text = participant.userNickName
        }
        if let userAvatar = participant.userAvatar, let url = URL(string: userAvatar) {
            avatar.sd_setImage(with: url)
        } else {
            avatar.image = #imageLiteral(resourceName: "avatar")
        }
        statusImageView.backgroundColor = participant.participationStatus.color
    }
}

// MARK: - IBAction
private extension ParticipantVC {
    
    @IBAction func profileToggle() {
        guard let userId = participant?.userId else { return }
        
        HelperTracking.track(item: .participantProfile)
        dismiss(animated: true) {
            self.delegate?.didTapOnParticipantProfile(userId: userId)
        }
    }

    @IBAction func acceptToggle() {
        guard let event = self.event,
              let eventId = event.id,
              let participant = self.participant,
              participant.status != ParticipationStatus.accepted.rawValue else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        HelperTracking.track(item: .participantAccept)
        ServiceEvent.acceptParticipant(eventId: eventId, participant: participant)
        ServiceNotification.acceptYourParticipation(event: event, participant: participant)
        delegate?.didAcceptParticipation(participant: participant)

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refuseToggle() {
        guard let event = self.event,
              let eventId = event.id,
              let participant = self.participant,
              participant.status != ParticipationStatus.refused.rawValue else {
            dismiss(animated: true, completion: nil)
            return
        }

        HelperTracking.track(item: .participantRefuse)
        ServiceEvent.refuseParticipant(eventId: eventId, participant: participant)
        if participant.status == ParticipationStatus.accepted.rawValue {
            ServiceNotification.refuseYourParticipation(event: event, participant: participant)
        }
        dismiss(animated: true, completion: nil)
    }
}

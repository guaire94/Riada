//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

protocol AddGuestVCDelegate: AnyObject {
    func didAddGuest(guest: Guest)
    func didUpdateNbAcceptedPlayerFromAddGuest(nbAcceptedPlayer: Int)
}

class AddGuestVC: MKeyboardVC {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "AddGuestVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nickNameTextField: MTextField!
    @IBOutlet weak private var addGuestButton: MButton!

    // MARK: - Properties
    weak var delegate: AddGuestVCDelegate?
    var event: Event?
    var asOrganizer: Bool = false

    var addGuestButtonIsEnabled: Bool = false {
        didSet {
            addGuestButton.alpha = addGuestButtonIsEnabled ? 1 : 0.5
            addGuestButton.isEnabled = addGuestButtonIsEnabled
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Privates
    private func setupView() {
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        addGuestButtonIsEnabled = false

        setupTextField()
    }
    
    private func setupTextField() {
        nickNameTextField.labelText = L10N.event.details.addGuest.nickName.text
        nickNameTextField.placeHolder = L10N.event.details.addGuest.nickName.placeHolder
        nickNameTextField.delegate = self
        nickNameTextField.returnKeyType = .done
    }
}

// MARK: - UITextFieldDelegate
extension AddGuestVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var nickName = textField.text ?? ""
        if string == "\n" {
            textField.resignFirstResponder()
            addGuestToggle()
            return false
        }
        if string.count > 0 {
            nickName = nickName + string
        } else if string.count == 0 && nickName.count > 0 {
            nickName.removeLast()
        }
        addGuestButtonIsEnabled = nickName.count > 2
        return true
    }
}

// MARK: - IBAction
private extension AddGuestVC {

    @IBAction func addGuestToggle() {
        guard let event = event,
              let eventId = event.id,
              addGuestButtonIsEnabled,
              let guestNickName = nickNameTextField.text,
              let user = ManagerUser.shared.user,
              let userId = user.id,
              let userNickname = user.nickName else {
            return
        }
        
        HelperTracking.track(item: .guestAddNickname)
        ServiceEvent.addGuest(eventId: eventId, nickName: guestNickName, asOrganizer: asOrganizer)
        if asOrganizer {
            ServiceEvent.increaseNbAcceptedPlayer(eventId: eventId)
            let nbAcceptedPlayer = event.nbAcceptedPlayer+1
            delegate?.didUpdateNbAcceptedPlayerFromAddGuest(nbAcceptedPlayer: nbAcceptedPlayer)
        }
        
        let guest = Guest(id: "",
                          associatedUserId: userId,
                          associatedUserNickName: userNickname,
                          associatedUserAvatar: user.avatar,
                          guestNickName: guestNickName,
                          status: ParticipationStatus.accepted.rawValue)
        
        delegate?.didAddGuest(guest: guest)
        
        dismiss(animated: true, completion: nil)
    }
}

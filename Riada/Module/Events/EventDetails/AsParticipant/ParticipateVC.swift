//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

class ParticipateVC: MKeyboardVC {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "ParticipateVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nickNameTextField: MTextField!
    @IBOutlet weak private var participateButton: MButton!

    // MARK: - Properties
    var event: Event?
    
    var partcipateButtonIsEnabled: Bool = false {
        didSet {
            participateButton.alpha = partcipateButtonIsEnabled ? 1 : 0.5
            participateButton.isEnabled = partcipateButtonIsEnabled
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
        setUpTextField()
        setUpButtons()
    }
}

// MARK: - Privates
private extension ParticipateVC {

    func setUpTextField() {
        nickNameTextField.labelText = L10N.event.details.participate.nickName.text
        nickNameTextField.placeHolder = L10N.event.details.participate.nickName.placeHolder
        nickNameTextField.delegate = self
        nickNameTextField.returnKeyType = .done
    }

    func setUpButtons() {
        partcipateButtonIsEnabled = false
        participateButton.setTitle(L10N.event.details.buttons.participate, for: .normal)
    }
}

// MARK: - UITextFieldDelegate
extension ParticipateVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var nickName = textField.text ?? ""
        if string == "\n" {
            textField.resignFirstResponder()
            participateToggle()
            return false
        }
        if string.count > 0 {
            nickName = nickName + string
        } else if string.count == 0 && nickName.count > 0 {
            nickName.removeLast()
        }
        partcipateButtonIsEnabled = nickName.count > 2
        return true
    }
}

// MARK: - IBAction
private extension ParticipateVC {

    @IBAction func participateToggle() {
        guard let event = self.event,
              partcipateButtonIsEnabled,
              let nickName = nickNameTextField.text else {
            return
        }
        
        HelperTracking.track(item: .participateAddNickname)
        ManagerUser.shared.updateNickName(nickName: nickName)

        HelperTracking.track(item: .eventDetailsParticipate)
        ServiceEvent.participate(event: event)
        dismiss(animated: true, completion: nil)
    }
}

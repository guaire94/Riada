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
        partcipateButtonIsEnabled = false

        setupTextField()
    }
    
    private func setupTextField() {
        nickNameTextField.labelText = L10N.event.details.participate.nickName.text
        nickNameTextField.placeHolder = L10N.event.details.participate.nickName.placeHolder
        nickNameTextField.delegate = self
        nickNameTextField.returnKeyType = .done
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
        guard let eventId = self.event?.id,
              partcipateButtonIsEnabled,
              let nickName = nickNameTextField.text else {
            return
        }
        
        ServiceUser.updateNickName(nickName: nickName)
        ServiceEvent.participate(eventId: eventId)
        dismiss(animated: true, completion: nil)
    }
}

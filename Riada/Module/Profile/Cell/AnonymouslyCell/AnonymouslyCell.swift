//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

protocol AnonymouslyCellDelegate: AnyObject {
    func didSignUpToggle(nickName: String?)
}

class AnonymouslyCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 166
        static let identifier: String = "AnonymouslyCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nickNameTextField: MTextField!
    @IBOutlet weak private var signUpButton: MButton!

    // MARK: - Properties
    weak var delegate: AnonymouslyCellDelegate?
    var isLoading: Bool = false {
        didSet {
            signUpButton.loadingIndicator(show: isLoading)
        }
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp() {
        setUpUI()
        setUpTranslation()
        setUpField()
    }
    
    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        nickNameTextField.delegate = self
    }
    
    private func setUpTranslation() {
        nickNameTextField.labelText = L10N.signUp.form.nickName
        nickNameTextField.placeHolder = L10N.signUp.form.nickNamePlaceHolder
        signUpButton.setTitle(L10N.signUp.form.signUp, for: .normal)
    }
    
    private func setUpField() {
        nickNameTextField.textContentType = .name
        nickNameTextField.returnKeyType = .done
    }
}

// MARK: - @IBAction
private extension AnonymouslyCell {
    
    @IBAction func signUpToggle() {
        delegate?.didSignUpToggle(nickName: nickNameTextField.text)
    }
}

// MARK: - UITextFieldDelegate
extension AnonymouslyCell: UITextFieldDelegate {
        
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        signUpToggle()
        return true
    }
}


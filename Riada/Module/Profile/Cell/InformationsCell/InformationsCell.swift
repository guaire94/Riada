//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class InformationsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 96
        static let identifier: String = "InformationsCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nickNameTextField: MTextField!

    // MARK: - Properties
    var nickName: String? {
        nickNameTextField.text
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp(delegate: UITextFieldDelegate) {
        nickNameTextField.delegate = delegate
        setUpUI()
        setUpTranslation()
        setUpField()
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
    }
    
    private func setUpTranslation() {
        nickNameTextField.labelText = L10N.signUp.form.nickName
        nickNameTextField.placeHolder = L10N.signUp.form.nickNamePlaceHolder
        nickNameTextField.text = ManagerUser.shared.user?.nickName
    }
    
    private func setUpField() {
        nickNameTextField.textContentType = .name
        nickNameTextField.returnKeyType = .done
    }
}

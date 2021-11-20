//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

protocol SignInCellDelegate: AnyObject {
    @available(iOS 13.0, *)
    func didSignInWithAppleToggle()
    func didSignInWithGoogleToggle()
}

class SignInCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 138
        static let identifier: String = "SignInCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var signInWithAppleButton: MButton!
    @IBOutlet weak private var signInWithGoogleButton: MButton!

    // MARK: - Properties
    weak var delegate: SignInCellDelegate?

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp() {
        setUpUI()
        setupSignInWithAppleButton()
        setupSignInWithGoogleButton()
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
    }
    
    private func setupSignInWithAppleButton() {
        guard #available(iOS 13, *) else {
            signInWithAppleButton.isHidden = true
            return
        }
        
        signInWithAppleButton.setTitle(L10N.signUp.signInWithApple, for: .normal)
    }
    
    private func setupSignInWithGoogleButton() {
        signInWithGoogleButton.setTitle(L10N.signUp.signInWithGoogle, for: .normal)
    }
}

// MARK: - IBActions
extension SignInCell {
    
    @available(iOS 13, *)
    @IBAction func signInWithAppleToggle() {
        delegate?.didSignInWithAppleToggle()
        signInWithAppleButton.loadingIndicator(show: true)
    }
    
    @IBAction func signInWithGoogleToggle() {
        delegate?.didSignInWithGoogleToggle()
        signInWithGoogleButton.loadingIndicator(show: true, color: .black)
    }
}

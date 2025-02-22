//
//  EventDetailsVC.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import UIKit
import AuthenticationServices
import Firebase
import GoogleSignIn

protocol SignUpVCDelegate: AnyObject {
    func didSignUp()
}

class SignUpVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "SignUpVC"
        static let bottomContentInset: CGFloat = 8.0
        static let googleProvider = "google.com"
        static let appleProvider = "apple.com"
        static let googleAvatarSize: UInt = 50
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var welcomeLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties
    private var anonymouslyCell: AnonymouslyCell?
    private var signInCell: SignInCell?

    private var sections = MSignUpSection.toDisplay()
    private var currentNonce: String?
    weak var delegate: SignUpVCDelegate?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    //MARK: - Privates
    private func setUpView() {
        welcomeLabel.text = L10N.signUp.welcome
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)
        tableView.register(SectionCell.Constants.nib,
                                forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        
        for section in sections {
            tableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    private func handleSignIn(credential: AuthCredential, nickName: String, avatarUrl: String? = nil) {
        ServiceUser.linkAccount(credential: credential) {
            ManagerUser.shared.synchronise {
                if !nickName.isEmpty {
                    ManagerUser.shared.updateNickName(nickName: nickName)
                }
                if let avatarUrl = avatarUrl, !avatarUrl.isEmpty {
                    ManagerUser.shared.updateAvatar(avatarUrl: avatarUrl)
                }
                if credential.provider == Constants.googleProvider {
                    self.signInCell?.isGoogleLoading = false
                } else if credential.provider == Constants.appleProvider {
                    self.signInCell?.isAppleLoading = false
                }
                self.dismiss(animated: true)
                self.delegate?.didSignUp()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SignUpVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SectionCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else {
            return nil
        }
        let eventSection = sections[section]        
        header.setUp(desc: eventSection.desc)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .anonymously, .signIn:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .anonymously:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? AnonymouslyCell else {
                  return UITableViewCell()
              }
            cell.delegate = self
            cell.setUp()
            anonymouslyCell = cell
            return cell
        case .signIn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? SignInCell else {
                  return UITableViewCell()
              }
            cell.delegate = self
            cell.setUp()
            signInCell = cell
            return cell
        }
    }
}

// MARK: AnonymouslyCellDelegate
extension SignUpVC: AnonymouslyCellDelegate {
    
    func didSignUpToggle(nickName: String?) {
        guard let nickName = nickName,
              !nickName.isEmpty else {
            showError(title: L10N.signUp.form.signUp, message: L10N.signUp.form.error.unfill)
            return
        }
        anonymouslyCell?.isLoading = true
        HelperTracking.track(item: .signUpWithNickname)
        ManagerUser.shared.updateNickName(nickName: nickName)
        dismiss(animated: true) {
            self.anonymouslyCell?.isLoading = false
            self.delegate?.didSignUp()
        }
    }
}

// MARK: - IBActions
extension SignUpVC: SignInCellDelegate {
    
    @available(iOS 13.0, *)
    func didSignInWithAppleToggle() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        HelperTracking.track(item: .signUpWithApple)
        
        signInCell?.isAppleLoading = true
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func didSignInWithGoogleToggle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        HelperTracking.track(item: .signUpWithGoogle)

        signInCell?.isGoogleLoading = true
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            guard error == nil,
                let authentication = user?.authentication,
                let idToken = authentication.idToken else {
                    self.signInCell?.isGoogleLoading = false
                    return
                }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            let nickName = user?.profile?.name ?? ""
            let avatarUrl = user?.profile?.imageURL(withDimension: Constants.googleAvatarSize)?.absoluteString
            self.handleSignIn(credential: credential, nickName: nickName, avatarUrl: avatarUrl)
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                      signInCell?.isAppleLoading = false
                      showError(title: L10N.signUp.signInWithApple, message: L10N.signUp.error.withApple)
                      return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            let nickName = appleIDCredential.fullName?.username ?? ""
            handleSignIn(credential: credential, nickName: nickName)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInCell?.isAppleLoading = false
        showError(title: L10N.signUp.signInWithApple, message: error.localizedDescription)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}

// MARK: IBAction
private extension SignUpVC {
    
    @IBAction func backToggle(_ sender: Any) {
        dismiss(animated: true)
    }
}




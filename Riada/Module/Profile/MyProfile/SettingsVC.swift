//
//  SettingsVC.swift
//  Riada
//
//  Created by Guaire94 on 14/11/2021.
//

import UIKit
import MessageUI
import FirebaseMessaging
import Firebase
import FirebaseInstanceID
import StoreKit

class SettingVC: UIViewController {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "SettingVC"

        fileprivate enum EmailInformation {
            static let email: String = "riada.application@gmail.com"
            static let subject: String = "[RIADA][FEEDBACK]"
            static let gmailScheme: String = "googlegmail://"
        }
        fileprivate enum SendEmailAlert {
            static let apple: String = "Apple mail"
            static let gmail: String = "Gmail"
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
            
    // MARK: - Properties
    private var sections = MSettingSection.toDisplay()
    private var emailBody: String {
        var result: String = "\n\n\n"
        result += "System: \(UIDevice.current.systemVersion)\n"
        result += "Device: \(UIDevice.current.modelName)\n"
        guard let infoDictionary = Bundle.main.infoDictionary,
              let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return result
        }
        
        result += "Version: \(version)"
        return result
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
    }
    
    func setUpView() {
        HelperTracking.track(item: .myProfileSettings)
        titleLabel.text = L10N.setting.title
    }
    
    private func setUpTableView() {
        for section in sections {
            tableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func sendMail() {
        HelperTracking.track(item: .settingsContactUs)
        let canSendViaAppleMail = MFMailComposeViewController.canSendMail()
        
        var canSendViaGmail = false
        if let url = URL(string: Constants.EmailInformation.gmailScheme) {
           canSendViaGmail = UIApplication.shared.canOpenURL(url)
        }
        
        switch (canSendViaAppleMail, canSendViaGmail) {
        case (true, true):
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Constants.SendEmailAlert.apple, style: .default, handler: { (_) in
                self.sendViaAppleMail()
            }))
            
            alert.addAction(UIAlertAction(title: Constants.SendEmailAlert.gmail, style: .default, handler: { (_) in
                self.sendViaGmail()
            }))
            
            alert.addAction(UIAlertAction(title: L10N.global.action.cancel, style: .cancel, handler: nil))
            
            present(alert, animated: true)
        case (true, false):
            sendViaAppleMail()
        case (false, true):
            sendViaGmail()
        default:
            showError(title: L10N.setting.noContactEmail.title, message: L10N.setting.noContactEmail.message(Constants.EmailInformation.email))
        }
    }
    
    private func sendViaAppleMail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([Constants.EmailInformation.email])
        composeVC.setSubject(Constants.EmailInformation.subject)
        composeVC.setMessageBody(emailBody, isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    private func sendViaGmail() {
        let to = Constants.EmailInformation.email
        guard let subject = Constants.EmailInformation.subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let emailBody = emailBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.EmailInformation.gmailScheme)co?to=\(to)&subject=\(subject)&body=\(emailBody)") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Tableview more
extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SettingCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:SettingCell = tableView.dequeueReusableCell(withIdentifier: SettingCell.Constants.identifier, for: indexPath)
            as? SettingCell else {
                return UITableViewCell()
        }
        let setting = sections[indexPath.row]
        cell.setUp(setting: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = sections[indexPath.row]
        
        switch setting {
        case .notifications:
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            HelperTracking.track(item: .settingsNotifications)
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        case .rateApp:
            HelperTracking.track(item: .settingsRateApp)
            SKStoreReviewController.requestReview()
        case .contactUs:
            sendMail()
        case .privacyPolicy:
            guard let urlString = setting.url, let url = URL(string: urlString) else { return }
            HelperTracking.track(item: .settingsPrivacyPolicy)
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .termsAndConditions:
            guard let urlString = setting.url, let url = URL(string: urlString) else { return }
            HelperTracking.track(item: .settingsTermsAndConditions)
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .logout:
            HelperTracking.track(item: .settingsLogout)
            ManagerUser.shared.signOut()
            dismiss(animated: true)
            HelperRouting.shared.routeToOnBoarding()
        }
    }
}

// MARK: - IBAction
extension SettingVC {
    
    @IBAction func backToggle(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

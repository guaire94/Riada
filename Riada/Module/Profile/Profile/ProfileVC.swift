//
//  EventDetailsVC.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "ProfileVC"
        static let bottomContentInset: CGFloat = 8.0
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var nickNameLabel: UILabel!
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var segmentControl: CustomSegmentedControl!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var actionButton: UIButton!

    //MARK: - Properties
    private var sections = MProfileSection.toDisplay()
    private var currentSection = MProfileSection.organizer {
        didSet {
            updateActionButton()
            
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OrganizeEventVC.Constants.identifier {
            guard let vc = segue.destination as? OrganizeEventVC else { return }
            vc.delegate = self
        }
    }
    
    //MARK: - Privates
    private func setUpView() {
        nickNameLabel.text = ManagerUser.shared.user?.nickName
        setUpSegmentControl()
        setUpTableView()
    }
    
    private func setUpSegmentControl() {
        segmentControl.delegate = self
        segmentControl.setButtonTitles(buttonTitles: sections.map({ $0.title }))
     }
    
    private func setUpTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)
        tableView.register(SectionCell.Constants.nib,
                                forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        
        for section in sections {
            tableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        tableView.dataSource = self
    }
    
    private func shareEvent(event: Event) {
        HelperDynamicLink.generateEventDetails(event: event, completion: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems : [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
    
    private func updateActionButton() {
        switch currentSection {
        case MProfileSection.organizer:
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "add"), for: .normal)
        case MProfileSection.participations:
            actionButton.isHidden = true
            actionButton.setImage(nil, for: .normal)
        case MProfileSection.informations:
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "save"), for: .normal)
        }
    }
}

// MARK: - CustomSegmentedControlDelegate
extension ProfileVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        guard let section = MProfileSection(rawValue: index) else { return }
        currentSection = section
    }
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        0 //sections.count
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SectionCell.Constants.height
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else {
//            return nil
//        }
//        let eventSection = sections[section]
//        header.setUp(desc: eventSection.desc)
//        return header
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        0.0
//        sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
//        switch sections[section] {
//        case .anonymously, .signIn:
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
//        let section = sections[indexPath.section]
//        switch section {
//        case .anonymously:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? AnonymouslyCell else {
//                      return UITableViewCell()
//                  }
//            cell.delegate = self
//            cell.setUp()
//            return cell
//        case .signIn:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? SignInCell else {
//                      return UITableViewCell()
//                  }
//            cell.delegate = self
//            cell.setUp()
//            return cell
//        }
    }
}

// MARK: - OrganizeEventVCDelegate
extension ProfileVC: OrganizeEventVCDelegate {

    func didCreateEvent(event: Event) {
        shareEvent(event: event)
    }
}

// MARK: IBAction
private extension ProfileVC {
    
    @IBAction func actionToggle(_ sender: Any) {
        switch currentSection {
        case MProfileSection.organizer:
            performSegue(withIdentifier: OrganizeEventVC.Constants.identifier, sender: self)
        case MProfileSection.informations:
            //TODO: edit profile validation
            break
        default:
            break
        }
    }
    
    @IBAction func settingsToggle(_ sender: Any) {
        // todo implement settings
        ManagerUser.shared.signOut()
        dismiss(animated: true)
        HelperRouting.shared.routeToOnBoarding()
    }
    
    @IBAction func backToggle(_ sender: Any) {
        dismiss(animated: true)
    }
}





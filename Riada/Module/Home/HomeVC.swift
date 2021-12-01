//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "HomeVC"
        fileprivate static let cornerRadius: CGFloat = 25
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var cityButton: UIButton!
    @IBOutlet weak private var userProfileButton: UIButton!
    @IBOutlet weak private var notificationsButton: UIButton!
    @IBOutlet weak private var sportsTableView: UITableView!
    
    // MARK: - Properties
    private var sports: [Sport] = []
    private var wantToOrganize = false

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as? AppDelegate)?.registerForPushNotifications()
        notificationsButton.isHidden = true
        setUpView()
        syncSports()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchLocationVC.Constants.identifier {
            guard let vc = segue.destination as? SearchLocationVC else { return }
            vc.delegate = self
            vc.searchType = .city
            vc.places = PlaceHolderCity.allCases.map({ GooglePlace(name: $0.name, id: $0.placeId) })
        } else if segue.identifier == OrganizeEventVC.Constants.identifier {
            guard let vc = segue.destination as? OrganizeEventVC else { return }
            vc.delegate = self
        } else if segue.identifier == SignUpVC.Constants.identifier {
            guard let vc = segue.destination as? SignUpVC else { return }
            vc.delegate = self
        } else if segue.identifier == MyProfileVC.Constants.identifier {
            guard let vc = segue.destination as? MyProfileVC else { return }
            vc.delegate = self
        } else if segue.identifier == NotificationsVC.Constants.identifier {
            guard let vc = segue.destination as? NotificationsVC else { return }
            vc.delegate = self
        } else if segue.identifier == EventDetailsAsOrganizerVC.Constants.identifier {
            guard let vc = segue.destination as? EventDetailsAsOrganizerVC,
                  let event = sender as? Event else {
                return
            }
            vc.event = event
        }
    }
    
    // MARK: - Privates
    private func setUpView() {
        HelperTracking.track(item: .home)

        cityButton.setTitle(ManagerUser.shared.currentCity.name, for: .normal)
        userProfileButton.layer.cornerRadius = Constants.cornerRadius
        userProfileButton.clipsToBounds = true
        setUpProfileInformations()
        setUpTableView()
    }
    
    private func setUpProfileInformations() {
        if let _ = ManagerUser.shared.user?.nickName {
            notificationsButton.isHidden = false
        }
        if let avatar = ManagerUser.shared.user?.avatar, let url = URL(string: avatar) {
            userProfileButton.sd_setImage(with: url, for: .normal, completed: nil)
        } else {
            userProfileButton.setImage(Config.defaultAvatar, for: .normal)
        }
    }

    private func setUpTableView() {
        sportsTableView.register(SportCell.Constants.nib, forCellReuseIdentifier: SportCell.Constants.identifier)
        sportsTableView.dataSource = self
        sportsTableView.delegate = self
    }
    
    private func syncSports() {
        sports = ManagerSport.shared.sports
        sportsTableView.reloadData()
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
}

// MARK: - IBAction
private extension HomeVC {

    @IBAction func locationToggle(_ sender: Any) {
        HelperTracking.track(item: .homeSearchCity)
        performSegue(withIdentifier: SearchLocationVC.Constants.identifier, sender: self)
    }
    
    @IBAction func profileToggle(_ sender: Any) {
        HelperTracking.track(item: .homeProfile)
        if let _ = ManagerUser.shared.user?.nickName {
            performSegue(withIdentifier: MyProfileVC.Constants.identifier, sender: self)
        } else {
            performSegue(withIdentifier: SignUpVC.Constants.identifier, sender: self)
        }
    }

    @IBAction func organizeEventToggle(_ sender: Any) {
        HelperTracking.track(item: .homeOrganizeEvent)
        if let _ = ManagerUser.shared.user?.nickName {
            performSegue(withIdentifier: OrganizeEventVC.Constants.identifier, sender: self)
        } else {
            wantToOrganize = true
            performSegue(withIdentifier: SignUpVC.Constants.identifier, sender: self)
        }
    }
}


// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SportCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: SportCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? SportCell else {
            return UITableViewCell()
        }
        let sport = sports[indexPath.row]
        let isFavoriteSport = ManagerUser.shared.isFavoriteSport(sport: sport)
        cell.configure(sport: sport, isFavoriteSport: isFavoriteSport)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ManagerSport.shared.selectedSport = sports[indexPath.row]
        performSegue(withIdentifier: EventsVC.Constants.identifier, sender: self)
    }
}

// MARK:- SearchLocationVCDelegate
extension HomeVC: SearchLocationVCDelegate {
    
    func didSelectCity(city: City) {
        ManagerUserPreferences.shared.save(city: city)
        ManagerUser.shared.currentCity = city
        cityButton.setTitle(ManagerUser.shared.currentCity.name, for: .normal)
    }
}

// MARK: - OrganizeEventVCDelegate
extension HomeVC: OrganizeEventVCDelegate {

    func didCreateEvent(event: Event) {
        performSegue(withIdentifier: EventDetailsAsOrganizerVC.Constants.identifier, sender: event)
        shareEvent(event: event)
    }
}

// MARK: - SignUpVCDelegate
extension HomeVC: SignUpVCDelegate {

    func didSignUp() {
        notificationsButton.isHidden = false
        if wantToOrganize {
            wantToOrganize = false
            performSegue(withIdentifier: OrganizeEventVC.Constants.identifier, sender: self)
        } else {
            performSegue(withIdentifier: MyProfileVC.Constants.identifier, sender: self)
        }
    }
}

// MARK: - SignUpVCDelegate
extension HomeVC: MyProfileVCDelegate {

    func didUpdateAvatar() {
        setUpProfileInformations()
    }
}

// MARK: - NotificationsVCDelegate
extension HomeVC: NotificationsVCDelegate {

    func didTapNotification(deeplink: String) {
        guard let url = URL(string: deeplink) else { return }
        ManagerDeepLink.shared.setDeeplinkFromDeepLink(url: url)
        HelperRouting.shared.handleRedirect()
    }
}

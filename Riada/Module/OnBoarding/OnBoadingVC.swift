//
//  OnBoadingVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit
import AppTrackingTransparency

class OnBoardingVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var favoriteSportDescriptionLabel: UILabel!
    @IBOutlet weak var favoriteSportTableView: UITableView!
    @IBOutlet weak var letsPlayButton: MButton!
    
    // MARK: - IBOutlet
    private var sports: [Sport] = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTranslations()
        setupTableView()
        ServiceUser.signUpAnonymously()
        syncSports()
        requestTrackingAuthorization()
    }
    
    private func setupTranslations() {
        titleLabel.text = L10N.onBoarding.title
        appDescriptionLabel.text = L10N.onBoarding.appDescription
        favoriteSportDescriptionLabel.text = L10N.onBoarding.favoriteSportDescription
        letsPlayButton.setTitle(L10N.onBoarding.letsPlay.uppercased(), for: .normal)
    }
    
    private func setupTableView() {
        favoriteSportTableView.register(OnBoardingCell.Constants.nib,
                                        forCellReuseIdentifier: OnBoardingCell.Constants.identifier)
        favoriteSportTableView.dataSource = self
        favoriteSportTableView.delegate = self
    }
    
    private func syncSports() {
        sports = ManagerSport.shared.sports
        favoriteSportTableView.reloadData()
    }
    
    private func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization  { status in
                let trackingItem: Tracking
                switch status {
                case .authorized:
                    trackingItem = .trackingConsentAuthorized
                default:
                    trackingItem = .trackingConsentRejected
                }
                HelperTracking.track(item: trackingItem)
            }
        }
    }
}

// MARK: - IBAction
private extension OnBoardingVC {
        
    @IBAction func letsPlayToggle(_ sender: Any) {
        ManagerUser.shared.synchronise {
            HelperTracking.track(item: .welcomeLetsPlay)
            HelperRouting.shared.routeToHome()
        }
    }
}

// MARK: - UITableViewDataSource
extension OnBoardingVC: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        OnBoardingCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: OnBoardingCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? OnBoardingCell else {
            return UITableViewCell()
        }
        let sport = sports[indexPath.row]
        cell.configure(sport: sport)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OnBoardingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? OnBoardingCell else { return }
        cell.isMark = !cell.isMark
        let sport = sports[indexPath.row]
        if cell.isMark {
            HelperTracking.track(item: .welcomeAddFavoriteSport(sportName: sport.name))
            ManagerUser.shared.addFavoriteSport(sport: sport)
        } else {
            HelperTracking.track(item: .welcomeRemoveFavoriteSport(sportName: sport.name))
            ManagerUser.shared.removeFavoriteSport(sport: sport)
        }
    }
}

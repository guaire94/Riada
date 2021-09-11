//
//  OnBoadingVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

class OnBoardingVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var favoriteSportDescriptionLabel: UILabel!
    @IBOutlet weak var favoriteSportTableView: UITableView!
    @IBOutlet weak var letsPlayButton: UIButton!
    
    // MARK: - IBOutlet
    private var sports: [Sport] = []
    private var favoriteSports: [FavoriteSport] = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTranslations()
        setupTableView()
        ServiceUser.signUpAnonymously()
        syncSports()
    }
    
    private func setupTranslations() {
        titleLabel.text = L10N.onBoarding.title
        appDescriptionLabel.text = L10N.onBoarding.appDescription
        favoriteSportDescriptionLabel.text = L10N.onBoarding.favoriteSportDescription
        letsPlayButton.setTitle(L10N.onBoarding.letsPlay, for: .normal)
    }
    
    private func setupTableView() {
        favoriteSportTableView.register(OnBoardingCell.Constants.nib,
                                        forCellReuseIdentifier: OnBoardingCell.Constants.identifier)
        favoriteSportTableView.dataSource = self
        favoriteSportTableView.delegate = self
    }
    
    private func syncSports() {
        ServiceSport.getSports { (sports) in
            self.sports = sports
            self.favoriteSportTableView.reloadData()
        }
    }
    
}

// MARK: - IBAction
private extension OnBoardingVC {
        
    @IBAction func letsPlayToggle(_ sender: Any) {
        guard !favoriteSports.isEmpty else {
            HelperRouting.shared.routeToHome()
            return
        }
        ServiceUser.setFavoriteSports(favoriteSports: favoriteSports)
        ManagerAuth.shared.favoritesSport = favoriteSports
        HelperRouting.shared.routeToHome()
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
        let sport = sports[indexPath.row]
        let favoriteSport = FavoriteSport(from: sport)
        favoriteSports.append(favoriteSport)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let sport = sports[indexPath.row]
        guard let index = favoriteSports.firstIndex(where: { $0.id == sport.id }) else { return }
        favoriteSports.remove(at: index)
    }
}

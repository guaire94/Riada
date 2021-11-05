//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var cityButton: UIButton!
    @IBOutlet weak private var userProfileButton: UIButton!
    @IBOutlet weak private var sportsTableView: UITableView!
    
    // MARK: - Properties
    private var sports: [Sport] = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ManagerUser.shared.synchronise {
            self.setupView()
            self.syncSports()
        }
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
        }
    }
    
    // MARK: - Privates
    private func setupView() {
        cityButton.setTitle(ManagerUser.shared.currentCity.name, for: .normal)
        setupTableView()
    }

    private func setupTableView() {
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
        performSegue(withIdentifier: SearchLocationVC.Constants.identifier, sender: self)
    }
    
    @IBAction func profileToggle(_ sender: Any) {
        if let _ = ManagerUser.shared.user?.nickName {
            performSegue(withIdentifier: ProfileVC.Constants.identifier, sender: self)
        } else {
            performSegue(withIdentifier: SignUpVC.Constants.identifier, sender: self)
        }
    }

    @IBAction func organizeEventToggle(_ sender: Any) {
        if let _ = ManagerUser.shared.user?.nickName {
            performSegue(withIdentifier: OrganizeEventVC.Constants.identifier, sender: self)
        } else {
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
        shareEvent(event: event)
    }
}

// MARK: - SignUpVCDelegate
extension HomeVC: SignUpVCDelegate {

    func didSignUp() {
        performSegue(withIdentifier: ProfileVC.Constants.identifier, sender: self)
    }
}

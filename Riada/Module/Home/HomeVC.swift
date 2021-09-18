//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var cityButton: UIButton!
    @IBOutlet weak private var userProfileButton: UIButton!
    @IBOutlet weak private var sportsTableView: UITableView!
    
    // MARK: - Properties
    private var sports: [Sport] = []
    private var selectedSport: Sport?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        syncSports()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchLocationVC.Constants.identifier {
            guard let vc = segue.destination as? SearchLocationVC else { return }
            vc.delegate = self
        } else if segue.identifier == EventsVC.Constants.identifier {
            guard let vc = segue.destination as? EventsVC else { return }
            vc.sport = selectedSport
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
        ServiceSport.getSports { (sports) in
            self.sports = sports
            self.sportsTableView.reloadData()
        }
    }
}

// MARK: - IBAction
private extension HomeVC {

    @IBAction func locationToggle(_ sender: Any) {
        performSegue(withIdentifier: SearchLocationVC.Constants.identifier, sender: nil)
    }
    
    @IBAction func profileToggle(_ sender: Any) {
        // TODO: Reidrect to my profile
    }

    @IBAction func organizeEventToggle(_ sender: Any) {
        // TODO: Reidrect to organize event
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
        selectedSport = sports[indexPath.row]
        performSegue(withIdentifier: EventsVC.Constants.identifier, sender: nil)
    }
}

// MARK:- SearchLocationVCDelegate
extension HomeVC: SearchLocationVCDelegate {
    
    func didSelectLocation(city: City) {
        ManagerUserPreferences.shared.save(city: city)
        ManagerUser.shared.currentCity = city
        cityButton.setTitle(ManagerUser.shared.currentCity.name, for: .normal)
    }
}

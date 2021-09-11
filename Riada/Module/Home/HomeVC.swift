//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var sportsTableView: UITableView!
    
    // MARK: - IBOutlet
    private var sports: [Sport] = []

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        syncSports()
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

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SportCell.Constants.height
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
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Redirect to sport events
    }
}

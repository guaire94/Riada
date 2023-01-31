//
//  ProductCell.swift
//  Riada
//
//  Created by Quentin Gallois on 17/09/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit

class TeamCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier: String = "TeamCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }

    // MARK: - Properties
    private var team: Team?
    private var isEven: Bool = false
    private var members: [TeamMember] = []

    // MARK: - IBOutlet
    @IBOutlet weak private var teamTableView: UITableView!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        teamTableView.delegate = nil
        teamTableView.dataSource = nil
    }
    
    func setUp(team: Team, isEven: Bool, members: [TeamMember]) {
        setUpUI()

        self.team = team
        self.isEven = isEven
        self.members = members
        teamTableView.reloadData()
    }
}

// MARK: - Privates
private extension TeamCell {

    func setUpUI() {
        teamTableView.tableHeaderView = nil
        teamTableView.tableFooterView = nil
        teamTableView.register(TeamNameCell.Constants.nib,
                               forHeaderFooterViewReuseIdentifier: TeamNameCell.Constants.identifier)
        teamTableView.register(TeamMemberCell.Constants.nib,
                               forCellReuseIdentifier: TeamMemberCell.Constants.identifier)
        teamTableView.delegate = self
        teamTableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension TeamCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        TeamNameCell.Constants.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let team = self.team,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TeamNameCell.Constants.identifier) as? TeamNameCell else {
            return nil
          }
        header.setUp(teamName: team.teamName, isEven: isEven)
        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TeamMemberCell.Constants.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamMemberCell.Constants.identifier,
                                                       for: indexPath) as? TeamMemberCell else {
            return UITableViewCell()
        }
        cell.setUp(member: members[indexPath.row], isEven: isEven)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TeamCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Open action sheet (to open profile or remove my guest)
    }
}

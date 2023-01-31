//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventTeamsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 200
        static let identifier: String = "EventTeamsCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }

    // MARK: - Properties
    weak var delegate: EventPlaceWithPicturesCellDelegate?
    private var teams: [Team] = []
    private var participants: [Participant] = []
    private var guests: [Guest] = []
    private var currentPageIndex = 0

    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var teamsCollectionView: UICollectionView!
    @IBOutlet weak private var teamsCollectionViewHeight: NSLayoutConstraint!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }

    func setUp(teams: [Team], participants: [Participant], guests: [Guest]) {
        setUpUI()

        self.participants = participants
        self.guests = guests
        self.teams = teams
        computeMaxHeight()
        teamsCollectionView.reloadData()
    }
}


// MARK: - Privates
private extension EventTeamsCell {
    func setUpUI() {
        selectionStyle = .none
        setUpCollectionView()
    }

    func setUpCollectionView() {
        teamsCollectionView.register(TeamCell.Constants.nib,
                                     forCellWithReuseIdentifier: TeamCell.Constants.identifier)
        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self
    }

    func computeMaxHeight() {
        var nbMaxTeamMember = 0
        for t in teams {
            let nbTeamMember = participants.filter({$0.teamId == t.id}).count + guests.filter({$0.teamId == t.id}).count
            nbMaxTeamMember = max(nbMaxTeamMember, nbTeamMember)
        }
        teamsCollectionViewHeight.constant = (CGFloat(nbMaxTeamMember) * TeamMemberCell.Constants.height) + TeamMemberCell.Constants.height
        teamsCollectionView.layoutSubviews()
    }

    func computeTeamMember(team: Team) -> [TeamMember] {
        var teamMembers: [TeamMember] = []
        teamMembers.append(contentsOf: participants.filter({$0.teamId == team.id}).map({
            return TeamMember(userId: $0.userId,
                              userNickName: $0.userNickName,
                              userAvatar: $0.userAvatar,
                              isGuest: false)
        }))
        teamMembers.append(contentsOf: guests.filter({$0.teamId == team.id}).map({
            let userNickName = String(format: L10N.event.details.guestBy,
                                      arguments: [$0.guestNickName, $0.associatedUserNickName])
            return TeamMember(userId: $0.associatedUserId,
                              userNickName: userNickName,
                              userAvatar: $0.associatedUserAvatar,
                              isGuest: true)
        }))
        return teamMembers
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EventTeamsCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if teams.count % 2 != 0 && indexPath.row == (teams.count - 1) {
            return CGSize(width: collectionView.frame.width, height: teamsCollectionViewHeight.constant)
        } else {
            return CGSize(width: collectionView.frame.width/2, height: teamsCollectionViewHeight.constant)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension EventTeamsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.Constants.identifier,
                                                            for: indexPath) as? TeamCell else {
            return UICollectionViewCell()
        }

        let team = teams[indexPath.row]
        let members = computeTeamMember(team: team)
        let isEven = indexPath.row % 2 == 0
        cell.setUp(team: team, isEven: isEven, members: members)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EventTeamsCell: UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let goingBack = scrollView.panGestureRecognizer.translation(in: scrollView).x > 0
        var index = currentPageIndex
        if goingBack {
            index -= 2
            if index < 0 {
                index = 0
            }
        } else {
            if (index + 2) < (teams.count - 1) {
                index += 2
            }
        }
        let indexPath = IndexPath(row: index, section: 0)
        teamsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        currentPageIndex = index
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Make any action regarding a team (complain that it should be more balance)
    }
}


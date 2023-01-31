//
//  EventMyGuestsCell.swift
//  Riada
//
//  Created by Quentin Gallois on 17/09/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit

protocol EventMyGuestsCellDelegate: AnyObject {
    func didToggleAddGuest()
    func didToggleGuest(guest: Guest)
}

class EventMyGuestsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 84.0
        static let identifier: String = "EventMyGuestsCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        static let topInset: CGFloat = 24.0
    }

    // MARK: - Properties
    weak var delegate: EventMyGuestsCellDelegate?
    private var guests: [Guest] = [] {
        didSet {
            computeMaxHeight()
            guestsTableView.reloadData()
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var guestsTableView: UITableView!
    @IBOutlet weak private var guestsTableViewHeight: NSLayoutConstraint!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        guestsTableView.delegate = nil
        guestsTableView.dataSource = nil
    }

    func setUp(guests: [Guest]) {
        setUpUI()

        self.guests = guests
    }
}

// MARK: - Privates
private extension EventMyGuestsCell {

    func setUpUI() {
        guestsTableView.tableHeaderView = nil
        guestsTableView.tableFooterView = nil
        guestsTableView.register(GuestSectionCell.Constants.nib,
                                 forHeaderFooterViewReuseIdentifier: GuestSectionCell.Constants.identifier)
        guestsTableView.register(GuestCell.Constants.nib,
                               forCellReuseIdentifier: GuestCell.Constants.identifier)
        guestsTableView.register(AddGuestCell.Constants.nib,
                               forCellReuseIdentifier: AddGuestCell.Constants.identifier)
        guestsTableView.delegate = self
        guestsTableView.dataSource = self
    }

    func computeMaxHeight() {
        guestsTableViewHeight.constant = GuestSectionCell.Constants.height + (CGFloat(guests.count) * GuestCell.Constants.height) + AddGuestCell.Constants.height + Constants.topInset
        guestsTableView.layoutSubviews()
    }
}

// MARK: - UITableViewDataSource
extension EventMyGuestsCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        GuestSectionCell.Constants.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GuestSectionCell.Constants.identifier) as? GuestSectionCell else {
            return nil
          }
        header.setUp()
        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guests.count == indexPath.row ? AddGuestCell.Constants.height : GuestCell.Constants.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guests.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if guests.count == indexPath.row {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestCell.Constants.identifier,
                                                           for: indexPath) as? AddGuestCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setUp()
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GuestCell.Constants.identifier,
                                                           for: indexPath) as? GuestCell else {
                return UITableViewCell()
            }
            cell.setUp(guest: guests[indexPath.row])
            return cell
        }
    }
}

// MARK: - AddGuestCellDelegate
extension EventMyGuestsCell: AddGuestCellDelegate {

    func didToggleAddGuest() {
        delegate?.didToggleAddGuest()
    }
}

// MARK: - UITableViewDelegate
extension EventMyGuestsCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if guests.count == indexPath.row {
            delegate?.didToggleAddGuest()
        } else {
            delegate?.didToggleGuest(guest: guests[indexPath.row])
        }
    }
}

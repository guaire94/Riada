//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

protocol AddGuestCellDelegate: AnyObject {
    func didToggleAddGuest()
}

class AddGuestCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 48
        static let identifier: String = "AddGuestCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let buttonCornerRadius: CGFloat = 16
    }

    // MARK: - Properties
    weak var delegate: AddGuestCellDelegate?

    // MARK: - IBOutlet
    @IBOutlet weak private var addButton: UIButton!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp() {
        selectionStyle = .none
        addButton.setTitle(L10N.event.details.buttons.addGuest, for: .normal)
        addButton.layer.cornerRadius = Constants.buttonCornerRadius
        addButton.clipsToBounds = true
    }
}


// MARK: - @IBAction
private extension AddGuestCell {

    @IBAction func didToggleAddGuest() {
        delegate?.didToggleAddGuest()
    }
}

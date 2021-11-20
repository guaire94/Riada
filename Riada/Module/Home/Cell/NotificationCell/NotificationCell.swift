//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class NotificationCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 78
        static let identifier: String = "NotificationCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    @IBOutlet weak private var deeplinkRedirectionImageView: UIImageView!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        titleLabel.text = ""
        bodyLabel.text = ""
    }
    
    func setUp(notification: Notification) {
        setUpUI()
        
        let titleArgs = notification.title_loc_args.map {NSLocalizedString($0, comment: "")}
        let title = String(format: NSLocalizedString(notification.title_loc_key, comment: ""), arguments: titleArgs)

        let bodyArgs = notification.body_loc_args.map {NSLocalizedString($0, comment: "")}
        let body = String(format: NSLocalizedString(notification.body_loc_key, comment: ""), arguments: bodyArgs)

        titleLabel.text = title
        bodyLabel.text = body
        guard let _ = notification.deeplink else {
            deeplinkRedirectionImageView.isHidden = true
            return
        }
        deeplinkRedirectionImageView.isHidden = false
    }
    
    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
    }
}

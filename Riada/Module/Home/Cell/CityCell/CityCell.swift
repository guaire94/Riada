//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CityCell: UITableViewCell {
    
    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 57
        static let identifier: String = "CityCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var cityNameLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    // Properties
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        selectionStyle = .none
    }
        
    func configure(name: String) {
        cityNameLabel.text = name
    }
}

//
//  ProductCell.swift
//  Riada
//
//  Created by Quentin Gallois on 17/09/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier: String = "PhotoCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var photoImageView: UIImageView!

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    func setUp(photoUrl: URL) {
        photoImageView.sd_setImage(with: photoUrl, completed: nil)
    }
}

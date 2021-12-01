//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

protocol EventPlaceWithPicturesCellDelegate: AnyObject {
    func didTogglePicture(photoUrl: URL)
}

class EventPlaceWithPicturesCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 216
        static let identifier: String = "EventPlaceWithPicturesCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var photosLabel: UILabel!
    @IBOutlet weak private var photosCollectionView: UICollectionView!

    // MARK: - Properties
    weak var delegate: EventPlaceWithPicturesCellDelegate?
    var photoUrls: [URL] = [] {
        didSet {
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
            }
        }
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
        nameLabel.text = ""
        addressLabel.text = ""
        photosLabel.text = ""
    }
    
    func setUp(name: String, address: String, photos: [URL]) {
        setUpUI()
        setUpCollectionView()
        
        nameLabel.text = name
        addressLabel.text = address
        photoUrls = photos
    }

    // MARK: - Private
    private func setUpUI() {
        selectionStyle = .none
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        photosLabel.text = L10N.event.details.photos
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        photosCollectionView.register(PhotoCell.Constants.nib, forCellWithReuseIdentifier: PhotoCell.Constants.identifier)
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EventPlaceWithPicturesCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.height * 1.3, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDataSource
extension EventPlaceWithPicturesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.Constants.identifier,
                                                            for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photoUrl = photoUrls[indexPath.row]
        cell.setUp(photoUrl: photoUrl)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EventPlaceWithPicturesCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoUrl = photoUrls[indexPath.row]
        delegate?.didTogglePicture(photoUrl: photoUrl)
    }
}

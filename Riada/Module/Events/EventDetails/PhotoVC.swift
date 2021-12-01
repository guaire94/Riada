//
//  PhotoVC.swift
//  Riada
//
//  Created by Guaire94 on 01/12/2021.
//

import UIKit

class PhotoVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "PhotoVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var photoImageView: UIImageView!

    // MARK: - Properties
    var photoUrl: URL?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Privates
    private func setupView() {
        guard let photoUrl = photoUrl else { return }
        photoImageView.sd_setImage(with: photoUrl, completed: nil)
    }
}

// MARK: - IBAction
private extension PhotoVC {

    @IBAction func backToggle() {
        dismiss(animated: true, completion: nil)
    }
}

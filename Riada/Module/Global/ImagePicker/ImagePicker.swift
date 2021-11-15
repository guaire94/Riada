//
//  MImagePicker.swift
//  Usiqee
//
//  Created by Amine on 01/05/2021.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didUpdateAvatar(image: UIImage)
}

class ImagePicker: UIView {

    // MARK: - Constants
    private enum Constants {
        static let identifier = "ImagePicker"
        fileprivate static let cornerRadius: CGFloat = 30
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    
    // MARK:- Properties
    weak var parentViewController: UIViewController?
    weak var delegate: ImagePickerDelegate?
    private var chosenImage: UIImage? {
        didSet {
            avatar.image = chosenImage
        }
    }
    var image: UIImage? {
        chosenImage
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupView() {
        avatar.layer.cornerRadius = Constants.cornerRadius
        avatar.clipsToBounds = true
    }
    
    func loadImage(from url: URL) {
        avatar.sd_setImage(with: url, completed: nil)
    }
    
    func setDefaultAvatar() {
        avatar.image = Config.defaultAvatar
    }
}

// MARK: - IBActions
extension ImagePicker {
    @IBAction func onImageTapped() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: L10N.profile.imagePicker.loadFromGallery, style: .default, handler: { _ in
            self.showPicker(from: .savedPhotosAlbum)
        }))
        alert.addAction(UIAlertAction(title: L10N.profile.imagePicker.takeAPhoto, style: .default, handler: { _ in
            self.showPicker(from: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: L10N.global.action.cancel, style: .cancel, handler: nil))
        
        parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func showPicker(from type: UIImagePickerController.SourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = type
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        parentViewController?.present(imagePickerVC, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        chosenImage = image
        delegate?.didUpdateAvatar(image: image)
    }
}

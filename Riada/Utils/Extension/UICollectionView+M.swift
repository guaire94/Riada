//
//  UICollectionView+M.swift
//  Riada
//
//  Created by Guaire94 on 24/09/2021.
//

import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "LatoBold", size: 20) ?? UIFont.systemFont(ofSize: 20)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
    }

    func restore() {
        backgroundView = nil
    }
}

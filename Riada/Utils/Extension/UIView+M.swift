//
//  UIView+M.swift
//  Riada
//
//  Created by Quentin Gallois on 30/10/2020.
//

import UIKit

extension UIView {

    func makeShadow(with color: UIColor = UIColor.lightGray,
                    offset: CGSize = CGSize(width: 3, height: 2)) {
        layer.cornerRadius = 16
        clipsToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = 1.0
    }
}

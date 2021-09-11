//
//  UIButton+M.swift
//  Riada
//
//  Created by Quentin Gallois on 28/10/2020.
//

import UIKit

var BUTTON_TITLE: String? = ""
var BUTTON_IMAGE: UIImage? = nil

extension UIButton {
    
    func loadingIndicator(show: Bool, color: UIColor = UIColor.white) {
        let tag = 1000
        if show {
            self.isEnabled = false
            
            BUTTON_TITLE = self.title(for: .normal)
            self.setTitle("", for: .normal)
            
            BUTTON_IMAGE = self.image(for: .normal)
            self.setImage(nil, for: .normal)
            
            let indicator = UIActivityIndicatorView()
            indicator.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            indicator.tag = tag
            indicator.color = color
            
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                    self.isEnabled = true
                    self.setTitle(BUTTON_TITLE, for: .normal)
                    self.setImage(BUTTON_IMAGE, for: .normal)
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
    }
}

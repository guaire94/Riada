//
//  MButton.swift
//  Riada
//
//  Created by Guaire94 on 24/09/2021.
//

import UIKit

class MButton: UIButton {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }    
}

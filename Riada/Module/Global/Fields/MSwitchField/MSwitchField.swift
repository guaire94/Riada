//
//  MPhoneOrMailTextField.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/03/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import UIKit

class MSwitchField: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var uiSwitch: UISwitch!
    
    // MARK: - Variables
    var isOn: Bool {
        uiSwitch.isOn
    }
    
    var labelText: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
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
        setUpView()
    }

    private func setUpView() {
        Bundle.main.loadNibNamed("MSwitchField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

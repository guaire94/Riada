//
//  MPhoneOrMailTextField.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/03/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import UIKit

protocol MPickerFieldDelegate: class {
    func didTogglePicker(sender: MPickerField)
}

class MPickerField: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var textField: UITextField!
    
    // MARK: - Variables
    weak var delegate: MPickerFieldDelegate?
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var labelText: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
    
    var isEnabled: Bool {
        get {
            textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
            textField.textColor = newValue ? .black : .gray
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
        Bundle.main.loadNibNamed("MPickerField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

// MARK: - IBAction
extension MPickerField {
    
    @IBAction func toggleField(_ sender: Any) {
        delegate?.didTogglePicker(sender: self)
    }
}

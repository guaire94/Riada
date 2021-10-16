//
//  MPhoneOrMailTextField.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/03/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import UIKit

class MTextField: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Variables
    var text: String? {
        get {
            guard let text = textField.text, !text.isEmpty else {
                return nil
            }
            return text
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
    
    var placeHolder: String? {
        get {
            textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }
    
    var delegate: UITextFieldDelegate? {
        get {
            textField.delegate
        }
        set {
            textField.delegate = newValue
        }
    }
    
    var textContentType: UITextContentType {
        get {
            textField.textContentType
        }
        set {
            textField.textContentType = newValue
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        get {
            textField.returnKeyType
        }
        set {
            textField.returnKeyType = newValue
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
        Bundle.main.loadNibNamed("MTextField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

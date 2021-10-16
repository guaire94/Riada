//
//  MPhoneOrMailTextField.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/03/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import UIKit

class MDatePickerField: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var datePicker: UIDatePicker!
    
    // MARK: - Variables
    var date: Date {
        get {
            datePicker.date
        }
        set {
            datePicker.date = newValue
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
    
    var mode: UIDatePicker.Mode {
        get {
            datePicker.datePickerMode
        }
        set {
            datePicker.datePickerMode = newValue
        }
    }
    
    var tint: UIColor {
        get {
            datePicker.tintColor
        }
        set {
            datePicker.tintColor = newValue
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
        setDatePicker()
    }

    private func setUpView() {
        Bundle.main.loadNibNamed("MDatePickerField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setDatePicker() {
        datePicker.minimumDate = Date()
    }
}

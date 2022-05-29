//
//  MTextView.swift
//  Riada
//
//  Created by Guaire94 on 29/05/2022.
//

import UIKit

class MTextView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Variables
    var text: String? {
        get {
            guard let text = textView.text, !text.isEmpty else {
                return nil
            }
            return text
        }
        set {
            textView.text = newValue
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
    
    var delegate: UITextViewDelegate? {
        get {
            textView.delegate
        }
        set {
            textView.delegate = newValue
        }
    }
    
    var textContentType: UITextContentType {
        get {
            textView.textContentType
        }
        set {
            textView.textContentType = newValue
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        get {
            textView.returnKeyType
        }
        set {
            textView.returnKeyType = newValue
        }
    }
    
    var inputAccessory: UIView? {
        get {
            textView.inputAccessoryView
        }
        set {
            textView.inputAccessoryView = newValue
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
        Bundle.main.loadNibNamed("MTextView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

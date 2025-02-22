//
//  UITextView+M.swift
//  Riada
//
//  Created by Guaire94 on 29/05/2022.
//

import UIKit

extension MTextView {
    
    func addDoneButton(target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: L10N.global.action.confirm, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessory = toolBar//5
    }
}

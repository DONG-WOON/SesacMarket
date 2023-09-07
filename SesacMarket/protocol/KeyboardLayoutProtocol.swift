//
//  KeyboardLayoutProtocol.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import UIKit

public protocol KeyboardLayoutProtocol: AnyObject {
    
    var keyboardHeight: CGFloat { get set }
    
    var keyboardWillShowToken: NSObjectProtocol? { get set }
    var keyboardWillHideToken: NSObjectProtocol? { get set }
}

extension KeyboardLayoutProtocol {
    
    func registerKeyboardLayoutNotification() {
        keyboardWillShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let keyboardRect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
            let keyboardHeight = keyboardRect.height
            self?.keyboardHeight = keyboardHeight
        }
        
        keyboardWillHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.keyboardHeight = 0
        }
    }
    
    func removeKeyboardLayoutNotification() {
        NotificationCenter.default.removeObserver(keyboardWillShowToken!)
        NotificationCenter.default.removeObserver(keyboardWillHideToken!)
    }
}

//
//  KeyboardHelper.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

public class KeyboardHelper {
    
    private let view: UIView
    private let scrollView: UIScrollView
    
    public init(view: UIView,
                scrollView: UIScrollView) {
        self.view = view
        self.scrollView = scrollView
    }
    
    public func startObserve() {
        NotificationCenter.default.addObserver(self,
                                 selector: #selector(adjustForKeyboard),
                                 name: UIResponder.keyboardWillShowNotification,
                                 object: nil)
        NotificationCenter.default.addObserver(self,
                                 selector: #selector(adjustForKeyboard),
                                 name: UIResponder.keyboardWillHideNotification,
                                 object: nil)
    }
    
    public func stopObserve() {
        NotificationCenter.default.removeObserver(self,
                                    name: UIResponder.keyboardWillShowNotification,
                                    object: nil)
        NotificationCenter.default.removeObserver(self,
                                    name: UIResponder.keyboardWillHideNotification,
                                    object: nil)
    }
    
    @objc
    private func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            scrollView.contentOffset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
}

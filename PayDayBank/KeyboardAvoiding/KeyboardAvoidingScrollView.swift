//
//  KeyboardAvoidingScrollView.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

open class KeyboardAvoidingScrollView: UIScrollView, KeyboardAvoidingProtocol {
    var _keyboardAvoider: KeyboardAvoider?
    var keyboardAvoider: KeyboardAvoider {
        
        if let keyboardAvoider: KeyboardAvoider = _keyboardAvoider {
            return keyboardAvoider
        } else {
            let result: KeyboardAvoider = KeyboardAvoider(scrollView: self)
            _keyboardAvoider = result
            return result
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    open func setup() {
        if contentSize.equalTo(CGSize.zero) {
            self.contentSize = self.bounds.size
        }

        keyboardAvoider.originalContentSize = self.contentSize
    }
    
    override open var frame: CGRect {
        didSet {
            var newContentSize: CGSize = keyboardAvoider.originalContentSize
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)
            
            super.contentSize = newContentSize
            
            if keyboardAvoider.isKeyboardVisible {
                self.contentInset = keyboardAvoider.contentInsetForKeyboard()
            }
        }
    }
    
    override open var contentSize: CGSize {
        set {
            keyboardAvoider.originalContentSize = newValue
            var newContentSize: CGSize = keyboardAvoider.originalContentSize
            newContentSize.width = max(newContentSize.width, self.frame.size.width)
            newContentSize.height = max(newContentSize.height, self.frame.size.height)
            
            super.contentSize = newContentSize
            
            if keyboardAvoider.isKeyboardVisible {
                self.contentInset = keyboardAvoider.contentInsetForKeyboard()
            }
        }
        
        get { return super.contentSize }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
     
        self.hideKeyBoard()
    }
    
    
    // MARK: - KeyboardAvoidingProtocol

    public func adjustOffset() {
        keyboardAvoider.adjustOffset()
    }

    public func hideKeyBoard() {
        keyboardAvoider.hideKeyBoard()
    }
    
    public func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder) {
        keyboardAvoider.addObjectForKeyboard(aObjectForKeyboard)
    }
    
    public func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder) {
        keyboardAvoider.removeObjectForKeyboard(aObjectForKeyboard)
    }
    
    public func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) {
        keyboardAvoider.addObjectsForKeyboard(aObjectsForKeyboard)
    }
    
    public func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) {
        keyboardAvoider.removeObjectsForKeyboard(aObjectsForKeyboard)
    }
    
    public func removeAllObjectsForKeyboard() {
        keyboardAvoider.removeAllObjectsForKeyboard()
    }
    
    public func responderShouldReturn(_ aResponder: UIResponder) {
        keyboardAvoider.responderShouldReturn(aResponder)
    }
}

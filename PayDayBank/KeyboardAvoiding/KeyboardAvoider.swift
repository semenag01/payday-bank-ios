//
//  KeyboardAvoider.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

open class KeyboardAvoider: KeyboardAvoidingProtocol {
    open var priorInset: UIEdgeInsets = UIEdgeInsets()
    open var isKeyboardVisible: Bool = false
    open var _keyboardRect: CGRect = CGRect.zero
    open var originalContentSize: CGSize = CGSize.zero
    open var objectsInKeyboard: [UIResponder] = []
    open var indexPathseObjectsInKeyboard: [IndexPath: [UIResponder]] = [:]
    open var lastReturnKeyType: UIReturnKeyType = UIReturnKeyType.go
    open var selectIndexInputField: Int = 0
    
    public weak var scrollView: UIScrollView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public init(scrollView aScrollView: UIScrollView) {
        scrollView = aScrollView
        setup()
    }
    
    open func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAvoider.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAvoider.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAvoider.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    open func contentInsetForKeyboard() -> UIEdgeInsets {
        guard let scrollView = scrollView else {
            return .zero
        }
        
        var result: UIEdgeInsets = scrollView.contentInset
        
        let keyboardRect: CGRect = self.keyboardRect()
        result.bottom = keyboardRect.size.height - ((keyboardRect.origin.y + keyboardRect.size.height) - (scrollView.bounds.origin.y + scrollView.bounds.size.height))
        if result.bottom < 0 {
            result.bottom = 0
        }
        
        return result
    }
    
    open func keyboardRect() -> CGRect {
        guard let scrollView = scrollView else {
            return .zero
        }
        
        var keyboardRect: CGRect = scrollView.convert(_keyboardRect, from: nil)
        
        if keyboardRect.origin.y == 0 {
            let screenBounds: CGRect = scrollView.convert(UIScreen.main.bounds, from: nil)
            keyboardRect.origin = CGPoint(x: 0, y: screenBounds.size.height - keyboardRect.size.height)
        }
        
        return keyboardRect
    }
    
    open func idealOffsetFor(view aView: UIView?, withSpace aSpace: CGFloat) -> CGFloat {
        guard let scrollView = scrollView else {
            return 0
        }
        
        var offset: CGFloat = 0
        
        if let view: UIView = aView {
            if let index: Int = objectsInKeyboard.firstIndex(of: view) {
                selectIndexInputField = index
            }
            
            let rect: CGRect = view.convert(view.bounds, to: scrollView)
            offset = rect.origin.y
            if scrollView.contentSize.height - offset < aSpace {
                offset -= (floor(aSpace - view.bounds.size.height) - 20)
            } else {
                if view.bounds.size.height < aSpace {
                    offset -= (floor(aSpace - view.bounds.size.height) - 20)
                }
                if offset + aSpace > scrollView.contentSize.height {
                    offset = scrollView.contentSize.height - aSpace
                }
            }
            if offset < 0 {
                offset = 0
            }
        }
        return offset
    }
    
    open func findFirstResponderBeneath(view aView: UIView) -> UIResponder? {
        var result: UIResponder?
        for childView: UIView in aView.subviews {
            if childView.responds(to: #selector(getter: UIResponder.isFirstResponder)) && childView.isFirstResponder {
                result = childView
                break
            }
            
            result = findFirstResponderBeneath(view: childView)
            if result != nil {
                break
            }
        }
        return result
    }
        
    // MARK: - NSNotification
    
    @objc open func keyboardWillShow(_ notification: Notification) {
        guard let scrollView = scrollView,
            let kbRect: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if kbRect.size.height > _keyboardRect.size.height || !isKeyboardVisible {
            if kbRect.size.height > 0 {
                _keyboardRect = kbRect
                isKeyboardVisible = true
                if let firstResponder: UIResponder = findFirstResponderBeneath(view: scrollView) {
                    if objectsInKeyboard.contains(firstResponder) {
                        selectIndexInputField = objectsInKeyboard.firstIndex(of: firstResponder) ?? 0
                    }
                    priorInset = scrollView.contentInset
                    scrollView.contentInset = contentInsetForKeyboard()
                    adjustOffset()
                }
            }
        }
    }
    
    @objc open func keyboardWillHide(_ notification: Notification) {
        _keyboardRect = CGRect.zero
        isKeyboardVisible = false
        selectIndexInputField = 0
        
        if let cgRectValue: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            _keyboardRect = cgRectValue
        }
        
        if let duration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: duration) {
                self.scrollView?.contentInset = self.priorInset
            }
        }
        adjustOffset()
    }
    
    @objc open func keyboardDidHide(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }

        if scrollView.contentOffset.y > 0 && scrollView.frame.size.height > scrollView.contentSize.height - 20 {
            scrollView.contentOffset = CGPoint.zero
        }
    }
    
    
    // MARK: - KeyboardAvoidingProtocol
    
    public func adjustOffset() {
        guard let scrollView = scrollView,
            isKeyboardVisible else {
            return
        }
        
        let visibleSpace: CGFloat = scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let idealOffset: CGPoint = CGPoint(x: 0, y: idealOffsetFor(view: findFirstResponderBeneath(view: scrollView) as? UIView, withSpace: visibleSpace))
        scrollView.setContentOffset(idealOffset, animated: true)
    }
    
    public func hideKeyBoard() {
        guard let scrollView = scrollView else {
                return
        }
        
        let responder: UIResponder? = findFirstResponderBeneath(view: scrollView)
        responder?.resignFirstResponder()
    }
    
    public func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder) {
        if objectsInKeyboard.count > 0 {
            (objectsInKeyboard.last as? UITextField)?.returnKeyType = UIReturnKeyType.next
            (objectsInKeyboard.last as? UITextView)?.returnKeyType = UIReturnKeyType.next
            (objectsInKeyboard.last as? UISearchBar)?.returnKeyType = UIReturnKeyType.next
        }
        
        (aObjectForKeyboard as? UITextField)?.returnKeyType = lastReturnKeyType
        (aObjectForKeyboard as? UITextView)?.returnKeyType = lastReturnKeyType
        (aObjectForKeyboard as? UISearchBar)?.returnKeyType = lastReturnKeyType
        objectsInKeyboard.append(aObjectForKeyboard)
        (aObjectForKeyboard as? KeyboardAvoiderProtocol)?.keyboardAvoiding = self
    }
    
    public func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder) {
        if objectsInKeyboard.contains(aObjectForKeyboard), let index: Int = objectsInKeyboard.firstIndex(of: aObjectForKeyboard) {
            objectsInKeyboard.remove(at: index)
            if objectsInKeyboard.count > 0 {
                (objectsInKeyboard.last as? UITextField)?.returnKeyType = lastReturnKeyType
                (objectsInKeyboard.last as? UITextView)?.returnKeyType = lastReturnKeyType
                (objectsInKeyboard.last as? UISearchBar)?.returnKeyType = lastReturnKeyType
            }
        }
        
        var deleteIndexPath: IndexPath?
        for сortege: (key: IndexPath, value: [UIResponder]) in indexPathseObjectsInKeyboard {
            let responders: [UIResponder] = сortege.value
            for obj: UIResponder in responders where obj == aObjectForKeyboard {
                deleteIndexPath = сortege.key
                break
            }
        }
        
        if let deleteIndexPath: IndexPath = deleteIndexPath {
            indexPathseObjectsInKeyboard.removeValue(forKey: deleteIndexPath)
        }
    }
    
    public func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) {
        for obj: UIResponder in aObjectsForKeyboard {
            addObjectForKeyboard(obj)
        }
    }
    
    public func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder]) {
        for obj: UIResponder in aObjectsForKeyboard {
            removeObjectForKeyboard(obj)
        }
    }
    
    public func removeAllObjectsForKeyboard() {
        objectsInKeyboard.removeAll()
        indexPathseObjectsInKeyboard.removeAll()
    }
    
    public func responderShouldReturn(_ aResponder: UIResponder) {
        let index: Int = objectsInKeyboard.firstIndex(of: aResponder) ?? NSNotFound
        
        assert(index != NSNotFound, String.init(format: "KeyboardAvoidingScrollView: _objectsInKeyboard is empty in %@", NSStringFromClass(type(of: self))))
        
        if index < objectsInKeyboard.count - 1 {
            selectIndexInputField = index + 1
            objectsInKeyboard[selectIndexInputField].becomeFirstResponder()
        } else {
            selectIndexInputField = 0
            aResponder.resignFirstResponder()
        }
    }
    
    open func setInputAccessoryView(_ aAccessoryView: UIView?) {
        for obj: UIResponder in objectsInKeyboard {
            (obj as? UITextField)?.inputAccessoryView = aAccessoryView
            (obj as? UITextView)?.inputAccessoryView = aAccessoryView
            (obj as? UISearchBar)?.inputAccessoryView = aAccessoryView
        }
    }
    
    func sortedResponders(_ aResponders: [UIResponder], byIndexPath aIndexPath: IndexPath) {
        objectsInKeyboard.removeAll()
        if indexPathseObjectsInKeyboard[aIndexPath] != nil {
            var temp: IndexPath = aIndexPath
            var tempIndexPathseObjectsInKeyboard: [IndexPath: [UIResponder]] = [:]
            for сortege: (key: IndexPath, value: [UIResponder]) in indexPathseObjectsInKeyboard {
                if сortege.key == temp {
                    if сortege.key == aIndexPath {
                        tempIndexPathseObjectsInKeyboard[aIndexPath] = aResponders
                        temp = IndexPath(row: сortege.key.row + 1, section: сortege.key.section)
                        tempIndexPathseObjectsInKeyboard[сortege.key] = indexPathseObjectsInKeyboard[temp]
                    }
                } else {
                    tempIndexPathseObjectsInKeyboard[сortege.key] = indexPathseObjectsInKeyboard[сortege.key]
                }
            }
            indexPathseObjectsInKeyboard = tempIndexPathseObjectsInKeyboard
        } else {
            indexPathseObjectsInKeyboard[aIndexPath] = aResponders
        }
        

        let sordetIndexPath: [(key: IndexPath, value: [UIResponder])] = indexPathseObjectsInKeyboard.sorted { (aCortege1, aCortege2) -> Bool in
            return aCortege1.key <= aCortege2.key
        }
        
        for сortege: (key: IndexPath, value: [UIResponder]) in sordetIndexPath {
            let responders: [UIResponder] = сortege.value
            for responder: UIResponder in сortege.value {
                (responder as? UITextField)?.returnKeyType = UIReturnKeyType.next
                (responder as? UITextView)?.returnKeyType = UIReturnKeyType.next
                (responder as? UISearchBar)?.returnKeyType = UIReturnKeyType.next
            }
            objectsInKeyboard.append(contentsOf: responders)
        }
        
        if objectsInKeyboard.count > 0 {
            (objectsInKeyboard.last as? UITextField)?.returnKeyType = lastReturnKeyType
            (objectsInKeyboard.last as? UITextView)?.returnKeyType = lastReturnKeyType
            (objectsInKeyboard.last as? UISearchBar)?.returnKeyType = lastReturnKeyType
        }
    }
}

//
//  KeyboardAvoiding.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

public protocol KeyboardAvoidingProtocol: class {
    func adjustOffset()
    func hideKeyBoard()
    
    func addObjectForKeyboard(_ aObjectForKeyboard: UIResponder)
    func removeObjectForKeyboard(_ aObjectForKeyboard: UIResponder)

    func addObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder])
    func removeObjectsForKeyboard(_ aObjectsForKeyboard: [UIResponder])

    func removeAllObjectsForKeyboard()
    
    func responderShouldReturn(_ aResponder: UIResponder)
}

public protocol KeyboardAvoiderProtocol: class {
    var keyboardAvoiding: KeyboardAvoidingProtocol? {get set}
}

//
//  SignInViewController.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class SignInViewController: ViewController {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var scrollView: KeyboardAvoidingScrollView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var output: SignInViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        setupTextFields()
    }
    
    private func setupTextFields() {
        scrollView.addObjectsForKeyboard([tfEmail, tfPassword])
        tfEmail.delegate = self
        tfPassword.delegate = self
        
        #if DEBUG
            tfEmail.text = "Nadiah.Spoel@example.com"
            tfPassword.text = "springs"
        #endif
    }
    
    // MARK: Actions
    
    @IBAction func didBtSignUpClicked(_ sender: Any) {
        output?.onSignUp()
    }
    
    @IBAction func didBtContinueClicked(_ sender: Any) {
        signIn()
    }
    
    private func signIn() {
        output?.signInWith(email: tfEmail.text, password: tfPassword.text)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfPassword {
            signIn()
        } else {
            scrollView.responderShouldReturn(textField)
        }
       return true
   }
}

extension SignInViewController: SignInViewInput {
    func showError(text: String?) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    func showActivity() {
        activity.startAnimating()
    }
    
    func hideActivity() {
        activity.stopAnimating()
    }
}

//
//  SignUpViewController.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class SignUpViewController: ViewController {
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var scrollView: KeyboardAvoidingScrollView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var output: SignUpViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        setupTextFields()
    }
    
    private func setupTextFields() {
        scrollView.addObjectsForKeyboard([tfFirstName,
                                          tfLastName,
                                          tfGender,
                                          tfDOB,
                                          tfPhone,
                                          tfEmail,
                                          tfPassword])
        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfGender.delegate = self
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfDOB.delegate = self
        tfPhone.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func didBtContinueClicked(_ sender: Any) {
        signUp()
    }
    
    private func signUp() {
        output?.signUpWith(firstName: tfFirstName.text,
                           lastName: tfLastName.text,
                           gender: tfGender.text,
                           email: tfEmail.text,
                           password: tfPassword.text,
                           dob: tfDOB.text,
                           phone: tfPhone.text)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfPassword {
            signUp()
        } else {
            scrollView.responderShouldReturn(textField)
        }
       return true
   }
}

extension SignUpViewController: SignUpViewInput {
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

//
//  ViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isUserVerified() { toList() }
    }

    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    @IBAction private func signUpButtonTapped(_ sender: Any) {
        signUp()
    }

    func toLogin() {
        //        self.performSegue(withIdentifier: R.segue.signUpViewController.toLogin, sender: self)
    }

    func toList() {
        //        self.performSegue(withIdentifier: R.segue.signUpViewController.toList, sender: self)
    }

    func signUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            authResult?.user.sendEmailVerification { [unowned self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.toLogin()
            }
        }
    }

    func isUserVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  LoginViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    private func initializeUI() {
        emailTextField.delegate = self
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
        logIn()
    }

    private func logIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
                return
            }

            guard let loginUser = authResult?.user else { return }

            if loginUser.isEmailVerified {
                self?.toList()
            } else {
                self?.presentValidateAlert()
            }
        }
    }

    private func presentValidateAlert() {
        let alert = UIAlertController(title: "error", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func toList() {
        guard let vc = R.storyboard.listViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

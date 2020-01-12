//
//  LoginViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import FontAwesome_swift
import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var authModel = AuthModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        initializeUI()
        configureModel()
    }

    private func configureNavigation() {
        navigationItem.title = "LogIn"
        navigationItem.removeBackBarButtonTitle()
    }

    private func initializeUI() {
        emailTextField.delegate = self
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }

    private func configureModel() {
        authModel = AuthModel()
        authModel.delegate = self
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
        logIn()
    }

    @objc
    private func back() {
        navigationController?.popViewController(animated: true)
    }

    private func logIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        authModel.login(with: email, and: password)
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

extension LogInViewController: AuthModelDelegate {
    func didLogIn(isEmailVerified: Bool) {
        if isEmailVerified {
            self.toList()
        } else {
            self.presentValidateAlert()
        }
    }
    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

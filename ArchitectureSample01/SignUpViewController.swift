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
        configureNavigation()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isUserVerified() { toList() }
    }

    private func configureNavigation() {
        title = "SignUp"
        navigationItem.removeBackBarButtonTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogIn", style: .plain, target: self, action: #selector(self.toLogIn))
    }

    private func configureView() {
        emailTextField.delegate = self
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }

    @IBAction private func signUpButtonTapped(_ sender: Any) {
        signUp()
    }

    @objc
    private func toLogIn() {
        guard let vc = R.storyboard.logInViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    private func toList() {
        guard let vc = R.storyboard.listViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: false)
    }

    private func signUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
                return
            }
            authResult?.user.sendEmailVerification { [weak self] error in
                if let error = error {
                    let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                    return
                }
                self?.toLogIn()
            }
        }
    }

    private func isUserVerified() -> Bool {
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

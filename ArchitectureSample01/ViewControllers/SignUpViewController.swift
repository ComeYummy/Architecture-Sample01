//
//  ViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

protocol SignUpViewInterface: class {
    var email: String? { get }
    var password: String? { get }
    func toList()
    func toLogin()
}

class SignUpViewController: UIViewController, SignUpViewInterface {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var presenter: SignUpPresenter!

    var email: String? {
        return self.emailTextField.text
    }
    var password: String? {
        return self.passwordTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
        initializePresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    private func configureNavigation() {
        title = "SignUp"
        navigationItem.removeBackBarButtonTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogIn", style: .plain, target: self, action: #selector(self.logInButtonTapped))
    }

    private func configureView() {
        emailTextField.delegate = self
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }

    func initializePresenter() {
        presenter = SignUpPresenter(with: self)
     }

    @IBAction private func signUpButtonTapped(_ sender: Any) {
        presenter.signUpButtonTapped()
    }

    @objc
    private func logInButtonTapped() {
        presenter.loginButtonTapped()
    }

    func toLogin() {
        guard let vc = R.storyboard.logInViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    func toList() {
        guard let vc = R.storyboard.listViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

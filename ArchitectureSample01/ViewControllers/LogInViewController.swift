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

protocol LoginViewInterface: class {
    var email: String? { get }
    var password: String? { get }
    func toList()
    func presentValidateAlert()
}

class LogInViewController: UIViewController, LoginViewInterface {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var presenter: LoginPresenter!

    var email: String? {
        return emailTextField.text
    }
    var password: String? {
        return passwordTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        initializeUI()
        initializePresenter()
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

    func initializePresenter() {
        presenter = LoginPresenter(with: self)
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
        presenter.loginButtonTapped()
    }

    func presentValidateAlert() {
        let alert = UIAlertController(title: "error", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func toList() {
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

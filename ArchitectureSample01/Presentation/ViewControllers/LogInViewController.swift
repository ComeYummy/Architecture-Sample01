//
//  LoginViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import FontAwesome_swift
import RxSwift
import RxCocoa
import UIKit

class LogInViewController: UIViewController {
    typealias ViewModelType = LogInViewModel

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    private var viewModel: ViewModelType!
    private let disposeBag = DisposeBag()

    func inject(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        bindViewModel()
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

    func bindViewModel() {
        let input = LogInViewModel.Input(
            loginTrigger: loginButton.rx.tap.asDriver(),
            email: emailTextField.rx.text
                .map { if let text = $0 { return text } else { return "" } }
                .asDriver(onErrorJustReturn: ""),
            password: passwordTextField.rx.text
                .map { if let text = $0 { return text } else { return "" } }
                .asDriver(onErrorJustReturn: "").asDriver()
        )
        let output = viewModel.transform(input: input)
        output.login.drive(onNext: userWillLogin).disposed(by: disposeBag)
    }

    func userWillLogin(user: User) {
        if !user.isEmailVerified {
            presentValidateAlert()
        }
    }

    func presentValidateAlert() {
        let alert = UIAlertController(title: "error", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

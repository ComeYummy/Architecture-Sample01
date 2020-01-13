//
//  ViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    var signUpViewModel: SignUpViewModel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
        initializeViewModel()
        bindViewModel()
    }

    private func configureNavigation() {
        title = "SignUp"
        navigationItem.removeBackBarButtonTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogIn", style: .plain, target: self, action: nil)
    }

    private func configureView() {
        emailTextField.delegate = self
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }

    func initializeViewModel() {
        signUpViewModel = SignUpViewModel(
            with: SignUpUseCase(with: AuthRepositoryImpl()),
            and: SignUpNavigator(with: self)
        )
    }

    func bindViewModel() {
        let input = SignUpViewModel.Input(
            checkLoginTrigger: rx.sentMessage(#selector(viewWillAppear(_:)))
                .map { _ in () }
                .asDriver(onErrorJustReturn: ()),
            loginTrigger: navigationItem.rightBarButtonItem!.rx.tap.asDriver(),
            signUpTrigger: signUpButton.rx.tap.asDriver(),
            email: emailTextField.rx.text
                .map { if let text = $0 { return text } else { return "" } }
                .asDriver(onErrorJustReturn: ""),
            password: passwordTextField.rx.text
                .map { if let text = $0 { return text } else { return "" } }
                .asDriver(onErrorJustReturn: "").asDriver()
        )
        let output = signUpViewModel.transform(input: input)
        output.checkLogin.drive().disposed(by: disposeBag)
        output.login.drive().disposed(by: disposeBag)
        output.signUp.drive().disposed(by: disposeBag)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

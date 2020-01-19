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
    typealias ViewModelType = SignUpViewModel

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    private var viewModel: ViewModelType!
    private let disposeBag = DisposeBag()

    func inject(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
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

    func bindViewModel() {
//        guard let viewModel = viewModel else { return }
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
        _ = viewModel.transform(input: input)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

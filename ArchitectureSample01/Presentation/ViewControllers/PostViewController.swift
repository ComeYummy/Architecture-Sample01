//
//  PostViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa
import UIKit

class PostViewController: UIViewController {
    typealias ViewModelType = PostViewModel

    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!

    private var viewModel: ViewModelType!
    private let disposeBag = DisposeBag()

    func inject(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func initializeUI() {
        postTextField.delegate = self
        let image = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .customBlack, size: CGSize(width: 48, height: 48))
        dismissButton.setImage(image, for: .normal)
    }

    func bindViewModel() {
        let input = PostViewModel.Input(
            postTrigger: postButton.rx.tap.asDriver(),
            content: postTextField.rx.text
                .map { if let text = $0 { return text } else { return "" } }
                .asDriver(onErrorJustReturn: ""),
            dismissTrigger: dismissButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        output.defaultPost.map { $0?.content }.drive(postTextField.rx.text).disposed(by: disposeBag)
    }

    func toList() {
        dismiss(animated: true)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTextField.resignFirstResponder()
        return true
    }
}

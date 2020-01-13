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

    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!

    var postViewModel: PostViewModel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeViewModel()
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

    func initializeViewModel(with selectedPost: Post? = nil) {
        guard postViewModel == nil else { return }
        postViewModel = PostViewModel(with: PostUseCase(with: FireBasePostRepository()),
                                      and: PostNavigator(with: self),
                                      and: selectedPost)
    }

    func bindViewModel() {
        let input = PostViewModel.Input(
            postTrigger: postButton.rx.tap.asDriver(),
            content: postTextField.rx.text
                .map { if let text = $0 { return text } else { return "" } }
                .asDriver(onErrorJustReturn: ""),
            dismissTrigger: dismissButton.rx.tap.asDriver()
        )
        let output = postViewModel.transform(input: input)
        output.post.drive().disposed(by: disposeBag)
        output.dismiss.drive().disposed(by: disposeBag)
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

//
//  PostViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

protocol PostViewInterface: class {
    func toList()
}

class PostViewController: UIViewController, PostViewInterface {

    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!

    var presenter: PostPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializePresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let post = presenter.selectedPost {
            postTextField.text = post.content
        }
    }

    @IBAction private func postButtonTapped(sender: UIButton) {
        guard let content = postTextField.text else { return }
        presenter.post(content)
    }

    @IBAction private func dismissButtonTapped(_ sender: Any) {
        presenter.dismiss()
    }

    private func initializeUI() {
        postTextField.delegate = self
        let image = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .customBlack, size: CGSize(width: 48, height: 48))
        dismissButton.setImage(image, for: .normal)
    }

    private func initializePresenter() {
        if presenter == nil { presenter = PostPresenter(with: self) }
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

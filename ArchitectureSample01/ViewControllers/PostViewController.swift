//
//  PostViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postTextField: UITextField!

    var postModel: PostModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        configureModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let post = postModel.selectedPost {
            postTextField.text = post.content
        }
    }

    @IBAction private func postButtonTapped(sender: UIButton) {
        guard let content = postTextField.text else { return }
        postModel.post(with: content)
    }

    private func initializeUI() {
        postTextField.delegate = self
    }

    private func configureModel() {
        if postModel == nil {
            postModel = PostModel()
        }
        postModel.delegate = self
    }
}

extension PostViewController: PostModelDelegate {
    func didPost() {
        print("Document added")
        dismiss(animated: true)
    }
    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTextField.resignFirstResponder()
        return true
    }
}

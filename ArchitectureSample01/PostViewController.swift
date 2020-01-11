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

    let db = Firestore.firestore()

    var selectedSnapshot: DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let snapshot = self.selectedSnapshot {
            postTextField.text = snapshot["content"] as? String
        }
    }

    @IBAction private func postButtonTapped(sender: UIButton) {
        if selectedSnapshot != nil {
            update()
        } else {
            create()
        }
    }

    private func initializeUI() {
        postTextField.delegate = self
    }

    private func create() {
        guard let text = postTextField.text else { return }

        db.collection("posts").addDocument(data: [
            "user": (Auth.auth().currentUser?.uid)!,
            "content": text,
            "date": Date()
        ]) { [unowned self] error in
            if let error = error {
                let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Error adding document: \(error)")
                return
            }
            print("Document added")
            self.dismiss(animated: true)
        }
    }

    private func update() {
        db.collection("posts").document(selectedSnapshot!.documentID).updateData([
            "content": self.postTextField.text!,
            "date": Date()
        ]) { [unowned self] error in
            if let error = error {
                let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Error adding document: \(error)")
                return
            }
            print("Document updated")
            self.dismiss(animated: true)
        }
    }

}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTextField.resignFirstResponder()
        return true
    }
}

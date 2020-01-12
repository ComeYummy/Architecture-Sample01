//
//  PostModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}

protocol PostModelDelegate: class {
    func didPost()
    func errorDidOccur(error: Error)
}

class PostModel {

    let db: Firestore

    let selectedPost: Post?

    weak var delegate: PostModelDelegate?

    init(with selectedPost: Post? = nil) {
        self.selectedPost = selectedPost
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
    }

    func post(with content: String) {
        if let post = selectedPost {
            db.collection("posts").document(post.id).updateData([
                "content": content,
                "date": Date()
            ]) { [unowned self] error in
                if let error = error {
                    self.delegate?.errorDidOccur(error: error)
                    return
                }
                self.delegate?.didPost()
            }
        } else {
            db.collection("posts").addDocument(data: [
                "user": (Auth.auth().currentUser?.uid)!,
                "content": content,
                "date": Date()
            ]) { [unowned self] error in
                if let error = error {
                    self.delegate?.errorDidOccur(error: error)
                    return
                }
                self.delegate?.didPost()
            }
        }
    }
}

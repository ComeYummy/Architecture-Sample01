//
//  ListPresenter.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase

class ListPresenter {
    weak var view: ListViewInterface?
    let postModel: PostModel
    let authModel: AuthModel

    var contentArray: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?

    var listener: ListenerRegistration?

    init(with view: ListViewInterface) {
        self.view = view
        self.postModel = PostModel()
        self.authModel = AuthModel()
        postModel.delegate = self
        authModel.delegate = self
    }

    func loadPosts() {
        self.listener = postModel.read()
    }

    func viewWillAppear() {
        selectedSnapshot = nil
    }

    func addButtonTapped() {
        view?.toPost()
    }

    func select(at index: Int) {
        selectedSnapshot = contentArray[index]
        view?.toPost()
    }

    func delete(at index: Int) {
        postModel.delete(contentArray[index].documentID)
        contentArray.remove(at: index)
    }

    func logOut() {
        authModel.logOut()
    }

    private func reload(with snapshot: QuerySnapshot) {
        if !snapshot.isEmpty {
            print(snapshot)
            contentArray.removeAll()
            for item in snapshot.documents {
                contentArray.append(item)
            }
            view?.reloadData()
        }
    }
}

extension ListPresenter: PostModelDelegate {
    func snapshotDidChange(snapshot: QuerySnapshot) {
        reload(with: snapshot)
    }
}

extension ListPresenter: AuthModelDelegate {
    func didLogOut() {
        view?.toBack()
    }
}

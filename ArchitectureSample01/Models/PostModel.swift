//
//  PostModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import RxSwift

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}

class PostModel {

    let db: Firestore

    var listener: ListenerRegistration?

    init() {
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
    }

    func create(with content: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("posts").addDocument(data: [
                "user": (Auth.auth().currentUser?.uid)!,
                "content": content,
                "date": Date()
            ]) { error in
                if let e = error {
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }

    func read() -> Observable<QuerySnapshot> {
        return Observable.create { [unowned self] observer in
            self.listener = self.db.collection("posts")
                .order(by: "date")
                .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                    guard let snap = snapshot else {
                        print("Error fetching document: \(error!)")
                        observer.onError(error!)
                        return
                    }
                    for diff in snap.documentChanges {
                        if diff.type == .added {
                            print("New data: \(diff.document.data())")
                        }
                    }
                    print("Current data: \(snap)")

                    observer.onNext(snap)
            }
            return Disposables.create()
        }
    }

    func update(_ post: Post) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("posts").document(post.id).updateData([
                "content": post.content,
                "date": post.date
                ]) { error in
                if let e = error {
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }

    func delete(_ documentID: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("posts").document(documentID).delete() { error in
                if let e = error {
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}

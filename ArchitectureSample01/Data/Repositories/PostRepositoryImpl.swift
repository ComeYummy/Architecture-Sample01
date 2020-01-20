//
//  FireBasePostRepository.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import RxSwift

class PostRepositoryImpl: PostRepository {

    static var shared: PostRepositoryImpl = PostRepositoryImpl()
    private init() {}

    func create(with content: String) -> Observable<Void> {
        return FireBasePostService.shared.create(with: content)
    }

    func read() -> Observable<[Post]> {
        return FireBasePostService.shared.read()
    }

    func update(_ post: Post) -> Observable<Void> {
        return FireBasePostService.shared.update(post)
    }

    func delete(_ documentID: String) -> Observable<Void> {
        return FireBasePostService.shared.delete(documentID)
    }
}

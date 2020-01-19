//
//  ListUseCase.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift

class ListUseCase {

    private let postRepository: PostRepository
    private let authRepository: AuthRepository

    init(postRepository: PostRepository, authRepository: AuthRepository) {
        self.postRepository = postRepository
        self.authRepository = authRepository
    }

    func loadPosts() -> Observable<[Post]> {
        return postRepository.read()
    }

    func delete(with id: String) -> Observable<Void> {
        return postRepository.delete(id)
    }

    func logOut() -> Observable<Void> {
        return authRepository.logOut()
    }
}

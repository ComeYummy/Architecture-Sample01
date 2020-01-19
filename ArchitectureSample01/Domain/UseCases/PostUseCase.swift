//
//  PostUseCase.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift

class PostUseCase {
    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func post(_ content: String) -> Observable<Void> {
        return postRepository
            .create(with: content)
    }

    func update(post: Post) -> Observable<Void> {
        return postRepository
            .update(post)
    }
}

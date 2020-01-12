//
//  PostViewModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel: ViewModelType {

    struct Input {
        let postTrigger: Driver<Void>
        let content: Driver<String>
        let dismissTrigger: Driver<Void>
    }

    struct Output {
        let post: Driver<Void>
        let defaultPost: Driver<Post?>
        let dismiss: Driver<Void>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let selectedPost: Post?
    private let postModel: PostModel
    private let navigator: PostNavigator

    init(with postModel: PostModel, and navigator: PostNavigator, and selectedPost: Post? = nil) {
        self.postModel = postModel
        self.navigator = navigator
        self.selectedPost = selectedPost
    }

    func transform(input: PostViewModel.Input) -> PostViewModel.Output {
        let state = State()
        let post = input.postTrigger
            .withLatestFrom(input.content)
            .flatMapLatest { [unowned self] content -> Driver<Void> in
                if let sP = self.selectedPost {
                    return self.postModel.update(
                        Post(id: sP.id,
                             user: sP.user,
                             content: content,
                             date: Date()))
                        .do(onNext: { [unowned self] _ in
                            self.navigator.toList()
                        })
                        .trackError(state.error)
                        .asDriver(onErrorJustReturn: ())
                } else {
                    return self.postModel.create(with: content)
                        .do(onNext: { [unowned self] _ in
                            self.navigator.toList()
                        })
                        .trackError(state.error)
                        .asDriver(onErrorJustReturn: ())
                }
        }
        let dismiss = input.dismissTrigger
            .do(onNext: { [unowned self] _ in
                self.navigator.toList()
            })

        return PostViewModel.Output(
            post: post,
            defaultPost: Driver.just(selectedPost),
            dismiss: dismiss,
            error: state.error.asDriver()
        )
    }
}

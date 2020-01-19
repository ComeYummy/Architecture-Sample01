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
    typealias UseCaseType = PostUseCase
    typealias WireframeType = PostWireframe

    struct Input {
        let postTrigger: Driver<Void>
        let content: Driver<String>
        let dismissTrigger: Driver<Void>
    }

    struct Output {
        let defaultPost: Driver<Post?>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let useCase: UseCaseType
    private let wireframe: WireframeType
    private var disposeBag = DisposeBag()

    private let selectedPost: Post?

    init(useCase: UseCaseType, wireframe: WireframeType, selectedPost: Post? = nil) {
        self.useCase = useCase
        self.wireframe = wireframe
        self.selectedPost = selectedPost
    }

    func transform(input: PostViewModel.Input) -> PostViewModel.Output {
        let state = State()

        input.postTrigger
            .withLatestFrom(input.content)
            .flatMapLatest { [unowned self] content -> Driver<Void> in
                if let sP = self.selectedPost {
                    return self.useCase.update(
                        post: Post(
                            id: sP.id,
                            user: sP.user,
                            content: content,
                            date: Date())
                        )
                        .trackError(state.error)
                        .asDriver(onErrorJustReturn: ())
                } else {
                    return self.useCase.post(content)
                        .trackError(state.error)
                        .asDriver(onErrorJustReturn: ())
                }
            }
            .asObservable()
            .flatMapLatest { [unowned self] _ in self.wireframe.toList() }
            .subscribe().disposed(by: disposeBag)

        input.dismissTrigger.asObservable()
            .flatMapLatest { [unowned self] _ in self.wireframe.toList() }
            .subscribe().disposed(by: disposeBag)

        return PostViewModel.Output(
            defaultPost: Driver.just(selectedPost),
            error: state.error.asDriver()
        )
    }
}

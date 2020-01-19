//
//  ListViewModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class ListViewModel: ViewModelType {
    typealias UseCaseType = ListUseCase
    typealias WireframeType = ListWireframe

    struct Input {
        let trigger: Driver<Void>
        let postTrigger: Driver<Void>
        let selectTrigger: Driver<Int>
        let deleteTrigger: Driver<Int>
        let logOutTrigger: Driver<Void>
    }

    struct Output {
        let posts: Driver<[Post]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }

    struct State {
        let contentArray = ArrayTracker<Post>()
        let isLoading = ActivityIndicator()
        let error = ErrorTracker()
    }

    private let useCase: UseCaseType
    private let wireframe: WireframeType
    private var disposeBag = DisposeBag()

    init(useCase: UseCaseType, wireframe: WireframeType) {
        self.useCase = useCase
        self.wireframe = wireframe
    }

    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let state = State()

        input.trigger
            .flatMap { [unowned self] _ in
                self.useCase.loadPosts()
                    .trackArray(state.contentArray)
                    .trackError(state.error)
                    .trackActivity(state.isLoading)
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            }
            .drive().disposed(by: disposeBag)

        input.selectTrigger
            .withLatestFrom(state.contentArray) { [unowned self] (index: Int, posts: [Post]) in
                self.wireframe.toPost(with: posts[index])
            }
            .drive().disposed(by: disposeBag)

        input.deleteTrigger
            .flatMapLatest { [unowned self] index in
                self.useCase.delete(with: state.contentArray.array[index].id)
                    .asDriver(onErrorJustReturn: ())
            }
            .drive().disposed(by: disposeBag)

        input.postTrigger.asObservable()
            .flatMapLatest { [unowned self] _ in self.wireframe.toPost(with: nil) }
            .subscribe().disposed(by: disposeBag)

        input.logOutTrigger.asObservable()
            .flatMapLatest { [unowned self] _ in self.useCase.logOut() }
            .flatMapLatest { [unowned self] _ in self.wireframe.toBack() }
            .subscribe().disposed(by: disposeBag)

        return ListViewModel.Output(posts: state.contentArray.asDriver(),
                                    isLoading: state.isLoading.asDriver(),
                                    error: state.error.asDriver())
    }
}

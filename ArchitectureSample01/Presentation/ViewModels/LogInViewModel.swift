//
//  LoginViewModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class LogInViewModel: ViewModelType {
    typealias UseCaseType = LogInUseCase
    typealias WireframeType = LogInWireframe

    struct Input {
        let loginTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }

    struct Output {
        let login: Driver<User>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let useCase: UseCaseType
    private let wireframe: WireframeType
    private var disposeBag = DisposeBag()

    init(useCase: UseCaseType, wireframe: WireframeType) {
        self.useCase = useCase
        self.wireframe = wireframe
    }

    func transform(input: LogInViewModel.Input) -> LogInViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.email, input.password)

        let login = input.loginTrigger.asObservable()
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (email: String, password: String) in
                self.useCase.login(with: email, and: password)
            }
            .trackError(state.error)
            .asDriverOnErrorJustComplete()

        login
            .map { $0.isEmailVerified }
            .filter { $0 }
            .asObservable()
            .flatMapLatest { [unowned self] _ in self.wireframe.toList() }
            .subscribe()
            .disposed(by: disposeBag)

        return LogInViewModel.Output(login: login, error: state.error.asDriver())
    }
}

//
//  SignUpViewModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    typealias UseCaseType = SignUpUseCase
    typealias WireframeType = SignUpWireframe

    struct Input {
        let checkLoginTrigger: Driver<Void>
        let loginTrigger: Driver<Void>
        let signUpTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }

    struct Output {
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

    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.email, input.password)

        input.signUpTrigger
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (email: String, password: String) in
                self.useCase.signUp(with: email, and: password)
                    .trackError(state.error)
                    .flatMapLatest { [unowned self] _ in
                        self.useCase.sendEmailVerification()
                            .trackError(state.error)
                    }
                    .asDriverOnErrorJustComplete()
            }
            .drive()
            .disposed(by: disposeBag)

        input.loginTrigger.asObservable()
            .flatMapLatest { [unowned self] _ in self.wireframe.toLogin() }
            .subscribe()
            .disposed(by: disposeBag)

        input.checkLoginTrigger.asObservable()
            .flatMapLatest { [unowned self] _ in self.useCase.checkLogIn() }
            .filter { $0 }
            .flatMapLatest { [unowned self] _ in self.wireframe.toList() }.debug()
            .subscribe()
            .disposed(by: disposeBag)

        return SignUpViewModel.Output()
    }
}

//
//  SignUpUseCase.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift

class SignUpUseCase {

    private let authRepository: AuthRepository

    init(with authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func checkLogIn() -> Observable<Bool> {
        return authRepository.checkLogin()
    }

    func signUp(with email: String, and password: String) -> Observable<User> {
        return authRepository
            .signUp(with: email, and: password)
    }

    func sendEmailVerification() -> Observable<Void> {
        return authRepository
            .sendEmailVerification()
    }
}

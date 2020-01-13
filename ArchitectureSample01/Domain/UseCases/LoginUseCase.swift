//
//  LoginUseCase.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift

class LoginUseCase {

    private let authRepository: AuthRepository

    init(with authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func login(with email: String, and password: String) -> Observable<User> {
        return authRepository.login(with: email, and: password)
    }
}

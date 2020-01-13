//
//  FireBaseAuthRepository.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import RxSwift

class AuthRepositoryImpl: AuthRepository {

    func checkLogin() -> Observable<Bool> {
        return FireBaseAuthService.shared.checkLogin()
    }

    func signUp(with email: String, and password: String) -> Observable<User> {
        return FireBaseAuthService.shared.signUp(with: email, and: password)
    }

    func sendEmailVerification() -> Observable<Void> {
        return FireBaseAuthService.shared.sendEmailVerification()
    }

    func login(with email: String, and password: String) -> Observable<User> {
        return FireBaseAuthService.shared.login(with: email, and: password)
    }

    func logOut() -> Observable<Void> {
        return FireBaseAuthService.shared.logOut()

    }
}

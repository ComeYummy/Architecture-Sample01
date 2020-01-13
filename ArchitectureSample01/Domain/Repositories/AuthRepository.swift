//
//  AuthRepository.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func checkLogin() -> Observable<Bool>
    func signUp(with email: String, and password: String) -> Observable<User>
    func sendEmailVerification() -> Observable<Void>
    func login(with email: String, and password: String) -> Observable<User>
    func logOut() -> Observable<Void>
}

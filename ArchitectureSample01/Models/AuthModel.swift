//
//  AuthModel.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase

@objc protocol AuthModelDelegate: class {
    @objc optional func didSignUp(newUser: User)
    @objc optional func didLogIn(isEmailVerified: Bool)
    @objc optional func emailVerificationDidSend()
    @objc optional func didLogOut()
    @objc optional func errorDidOccur(error: Error)
}

class AuthModel {
    weak var delegate: AuthModelDelegate?

    func signUp(with email: String, and password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (authResult, error) in
            if let e = error {
                self.delegate?.errorDidOccur?(error: e)
                return
            }
            guard let user = authResult?.user else { return }
            self.delegate?.didSignUp?(newUser: user)
        }
    }

    func sendEmailVerification(to user: User) {
        user.sendEmailVerification() { [unowned self] error in
            if let e = error {
                self.delegate?.errorDidOccur?(error: e)
                return
            }
            self.delegate?.emailVerificationDidSend?()
        }
    }

    func login(with email: String, and password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (authResult, error) in
            if let e = error {
                self.delegate?.errorDidOccur?(error: e)
                return
            }
            guard let loginUser = authResult?.user else { return }
            self.delegate?.didLogIn?(isEmailVerified: loginUser.isEmailVerified)
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.delegate?.didLogOut?()
        } catch {
            print("logout error")
        }
    }

    func isUserVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
}

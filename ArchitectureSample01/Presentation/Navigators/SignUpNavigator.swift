//
//  SignUpNavigator.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation

class SignUpNavigator {
    private weak var viewController: SignUpViewController?

    init(with viewController: SignUpViewController) {
        self.viewController = viewController
    }

    func toLogin() {
        guard let vc = R.storyboard.logInViewController.instantiateInitialViewController() else { return }
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func toList() {
        guard let vc = R.storyboard.listViewController.instantiateInitialViewController() else { return }
        viewController?.navigationController?.pushViewController(vc, animated: false)
    }
}

//
//  LoginNavigator.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation

class LoginNavigator {
    private weak var viewController: LogInViewController?

    init(with viewController: LogInViewController) {
        self.viewController = viewController
    }

    func toList() {
        guard let vc = R.storyboard.listViewController.instantiateInitialViewController() else { return }
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

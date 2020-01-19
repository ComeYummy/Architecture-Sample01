//
//  SignUpBuilder.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

struct SignUpBuilder {
func build() -> SignUpViewController {
        guard let viewController = R.storyboard.signUpViewController.signUpViewController() else {
            fatalError("Could not instantiate ViewController")
        }

        viewController.inject(
            viewModel: SignUpViewModel(
                useCase: SignUpUseCase(
                    authRepository: AuthRepositoryImpl.shared
                ),
                wireframe: SignUpWireframeImpl(viewController)
            )
        )
        return viewController
    }

    func buildWithNavigation() -> UINavigationController {
        let viewController = build()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

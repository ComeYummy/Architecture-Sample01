//
//  LogInBuilder.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

struct LogInBuilder {
    func build() -> LogInViewController {
        guard let viewController = R.storyboard.logInViewController.instantiateInitialViewController() else {
            fatalError("Could not instantiate ViewController")
        }

        viewController.inject(
            viewModel: LogInViewModel(
                useCase: LogInUseCase(
                    authRepository: AuthRepositoryImpl.shared
                ),
                wireframe: LogInWireframeImpl(viewController)
            )
        )
        return viewController
    }
}

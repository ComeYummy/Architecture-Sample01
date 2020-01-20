//
//  ListViewBuilder.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

struct ListViewBuilder {
    func build() -> ListViewController {
        guard let viewController = R.storyboard.listViewController.instantiateInitialViewController() else {
            fatalError("Could not instantiate ViewController")
        }

        viewController.inject(
            viewModel: ListViewModel(
                useCase: ListUseCase(
                    postRepository: PostRepositoryImpl.shared,
                    authRepository: AuthRepositoryImpl.shared
                ),
                wireframe: ListWireframeImpl(viewController)
            )
        )
        return viewController
    }
}

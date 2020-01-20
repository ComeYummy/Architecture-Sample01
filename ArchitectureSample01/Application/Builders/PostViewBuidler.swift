//
//  PostViewBuidler.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

struct PostViewBuidler {
    func build(_ selectedPost: Post? = nil) -> PostViewController {
        guard let viewController = R.storyboard.postViewController.instantiateInitialViewController() else {
            fatalError("Could not instantiate ViewController")
        }

        viewController.inject(
            viewModel: PostViewModel(
                useCase: PostUseCase(
                    postRepository: PostRepositoryImpl.shared
                ),
                wireframe: PostWireframeImpl(viewController),
                selectedPost: selectedPost
            )
        )
        return viewController
    }
}

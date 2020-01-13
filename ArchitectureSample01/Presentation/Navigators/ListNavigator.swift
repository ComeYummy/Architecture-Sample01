//
//  ListNavigator.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation

class ListNavigator {
    private weak var viewController: ListViewController?

    init(with viewController: ListViewController) {
        self.viewController = viewController
    }

    func toPost(with selectedPost: Post? = nil) {
        guard let vc = R.storyboard.postViewController.instantiateInitialViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.initializeViewModel(with: selectedPost)
        viewController?.present(vc, animated: true, completion: nil)
    }

    func toBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

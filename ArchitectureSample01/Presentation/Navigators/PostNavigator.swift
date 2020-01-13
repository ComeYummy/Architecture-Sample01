//
//  PostNavigator.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation

class PostNavigator {
    private weak var viewController: PostViewController?

    init(with viewController: PostViewController) {
        self.viewController = viewController
    }

    func toList() {
        viewController?.dismiss(animated: true)
    }
}

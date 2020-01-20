//
//  PostWireframe.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift
import UIKit

protocol PostWireframe {
    func toList() -> Single<Void>
}

struct PostWireframeImpl: PostWireframe {
    private weak var viewController: PostViewController?

    init(_ viewController: PostViewController) {
        self.viewController = viewController
    }

    func toList() -> Single<Void> {
        viewController?.dismiss(animated: true)
        return Single.just(())
    }
}

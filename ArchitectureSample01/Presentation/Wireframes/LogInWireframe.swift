//
//  LogInWireframe.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift
import UIKit

protocol LogInWireframe {
    func toList() -> Single<Void>
}

struct LogInWireframeImpl: LogInWireframe {
    private weak var viewController: LogInViewController?

    init(_ viewController: LogInViewController) {
        self.viewController = viewController
    }

    func toList() -> Single<Void> {
        let vc = ListViewBuilder().build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
        return Single.just(())
    }
}

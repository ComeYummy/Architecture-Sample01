//
//  SignUpWireframe.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift
import UIKit

protocol SignUpWireframe {
    func toLogin() -> Single<Void>
    func toList() -> Single<Void>
}

struct SignUpWireframeImpl: SignUpWireframe {
    private weak var viewController: SignUpViewController?

    init(_ viewController: SignUpViewController) {
        self.viewController = viewController
    }

    func toLogin() -> Single<Void> {
        let vc = LogInBuilder().build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
        return Single.just(())
    }

    func toList() -> Single<Void> {
        let vc = ListViewBuilder().build()
        viewController?.navigationController?.pushViewController(vc, animated: false)
        return Single.just(())
    }

}

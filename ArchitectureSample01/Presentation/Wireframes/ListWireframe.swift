//
//  ListWireframe.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/18.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift
import UIKit

protocol ListWireframe {
    func toPost(with selectedPost: Post?) -> Single<Void>
    func toBack() -> Single<Void>
}

struct ListWireframeImpl: ListWireframe {
    private weak var viewController: ListViewController?

    init(_ viewController: ListViewController) {
        self.viewController = viewController
    }

    func toPost(with selectedPost: Post? = nil) -> Single<Void> {
        let vc = PostViewBuidler().build(selectedPost)
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
        return Single.just(())
    }

    func toBack() -> Single<Void> {
        viewController?.navigationController?.popViewController(animated: true)
        return Single.just(())
    }

}

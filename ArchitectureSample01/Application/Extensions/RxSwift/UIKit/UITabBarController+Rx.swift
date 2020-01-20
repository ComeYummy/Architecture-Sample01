//
//  UITabBarController+Rx.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift
import UIKit

extension Reactive where Base: UITabBarController {
    var selectedIndex: Observable<Int> {
        return observeWeakly(UIViewController.self, "selectedViewController")
            .flatMap { $0.map { Observable.just($0) } ?? Observable.empty() }
            .flatMap { [weak base] in
                return base?.viewControllers?.firstIndex(of: $0)
                    .map { Observable.just($0) } ?? Observable.empty()
            }
            .share(replay: 1)
    }
}

//
//  UIViewController+Rx.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<[Any]> {
        return sentMessage(#selector(base.viewDidLoad)).share(replay: 1)
    }

    var viewDidLoadAndNow: Observable<Void> {
        return viewDidLoad.mapToVoid().startWith(()).share(replay: 1)
    }

    var viewWillAppear: Observable<[Any]> {
        return sentMessage(#selector(base.viewWillAppear)).share(replay: 1)
    }

    var viewDidAppear: Observable<[Any]> {
        return sentMessage(#selector(base.viewDidAppear)).share(replay: 1)
    }

    var viewWillDisappear: Observable<[Any]> {
        return sentMessage(#selector(base.viewWillDisappear)).share(replay: 1)
    }

    /// 遷移完了時
    var viewDidDisappear: Observable<[Any]> {
        return sentMessage(#selector(base.viewDidDisappear)).share(replay: 1)
    }
}

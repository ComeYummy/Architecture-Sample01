//
//  UIRefreshControl+Rx.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIRefreshControl {
    var refresh: Observable<Void> {
        return controlEvent(.valueChanged)
            .map { [unowned base] in base.isRefreshing }
            .filter { $0 }.mapToVoid()
            .share(replay: 1)
    }
}

extension Reactive where Base: UIScrollView {
    var refresh: Observable<Void> {
        if base.refreshControl == nil {
            base.refreshControl = UIRefreshControl()
        }
        return base.refreshControl!.rx.refresh
    }

    /// ひっぱり更新中に上に戻すスクロール
    private func cancelRefreshing(_ withCancelAnimation: Bool = true) -> Observable<Void> {
        return didScroll.asObservable()
            .map { [unowned base] in min(0, -(base.contentOffset.y + base.contentInset.top)) }
            .filter { [unowned base] in base.refreshControl?.isRefreshing == true && $0 < 0 }
            .mapToVoid()
            .do(onNext: { [weak base] in
                if withCancelAnimation {
                    base?.refreshControl?.endRefreshing()
                }
            })
            // View の生成時は除外する
            .skip(1)
            .share(replay: 1)
    }

    func refreshing(_ withCancelAnimation: Bool = true) -> Observable<Bool> {
        if base.refreshControl == nil {
            base.refreshControl = UIRefreshControl()
        }
        return Observable.merge(base.refreshControl!.rx.refresh.mapToTrue(),
                                cancelRefreshing(withCancelAnimation).mapToFalse())
            .share(replay: 1)
    }
}

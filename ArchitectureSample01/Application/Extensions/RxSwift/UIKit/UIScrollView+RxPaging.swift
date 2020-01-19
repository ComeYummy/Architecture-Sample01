//
//  UIScrollView+RxPaging.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
    var pagingTrigger: Observable<Void> {
        return didScroll
            .withLatestFrom(contentOffset)
            .map { $0.y }
            .map { [unowned base] in base.contentSize.height - ($0 + base.bounds.height) }
            .filter { $0 <= 200 }
            .mapToVoid()
            .share(replay: 1)
    }

    var horizontalPagingTrigger: Observable<Void> {
        return didScroll
            .withLatestFrom(contentOffset)
            .map { $0.x }
            .map { [unowned base] in base.contentSize.width - ($0 + base.bounds.width) }
            .filter { $0 <= 200 }
            .mapToVoid()
            .share(replay: 1)
    }

    var currentPage: Observable<Int> {
        return didScroll
            .map { [unowned base] in base.contentOffset.x / base.frame.size.width }
            .map { Int(round($0)) }
            .distinctUntilChanged()
            .share(replay: 1)
    }
}

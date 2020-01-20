//
//  UIButton+Rx.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIButton {
//    /// タップ時に拡大させる
//    func applyExpandWhenTapped(_ scale: CGFloat = 1.3,
//                               duration: TimeInterval = 0.1,
//                               to view: UIView? = nil,
//                               when filterHandler: @escaping ((Bool) -> Bool) = { _ in true },
//                               completion completionHandler: @escaping ((Bool) -> Void) = { _ in }) -> Disposable {
//        return base.rx.touching
//            .filter(filterHandler)
//            .map { $0 ? CGAffineTransform(scaleX: scale, y: scale) : CGAffineTransform.identity }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned base] transform in
//                UIView.animate(withDuration: duration, animations: {
//                    (view ?? base).transform = transform
//                }, completion: completionHandler)
//            })
//    }

    /// Reactive wrapper for `TouchDown` control event.
    var touchDown: ControlEvent<Void> {
        return controlEvent(.touchDown)
    }

    /// Reactive wrapper for `TouchUpInside` control event.
    var touchUpInside: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }

    /// Reactive wrapper for `TouchCancel` control event.
    var touchCancel: ControlEvent<Void> {
        return controlEvent(.touchCancel)
    }

    /// Reactive wrapper for `TouchDragExit` control event.
    var touchDragExit: ControlEvent<Void> {
        return controlEvent(.touchDragExit)
    }

    /// Reactive wrapper for `TouchUpOutside` control event.
    var touchUpOutside: ControlEvent<Void> {
        return controlEvent(.touchUpOutside)
    }
}

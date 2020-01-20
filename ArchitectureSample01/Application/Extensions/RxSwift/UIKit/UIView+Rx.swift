//
//  UIView+Rx.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(base.layoutSubviews)).share(replay: 1)
    }

    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, backgroundColor in
            view.backgroundColor = backgroundColor
        }
    }

    var draw: Observable<[Any]> {
        return self.sentMessage(#selector(self.base.draw(_:))).share(replay: 1)
    }

    var longPressGesture: Observable<UILongPressGestureRecognizer> {
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        base.addGestureRecognizer(longPressGestureRecognizer)
        return longPressGestureRecognizer.rx.event.do(onDispose: {
            self.base.removeGestureRecognizer(longPressGestureRecognizer)
        }).share(replay: 1)
    }

    /// アニメーション付きの isHidden Binder
    var isHiddenWithAnimation: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            let alpha: CGFloat = hidden ? 0 : 1
            if !hidden {
                view.isHidden = hidden
            }
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = alpha
            }, completion: { _ in
                if hidden {
                    view.isHidden = hidden
                }
            })
        }
    }

    var isHiddenAnimated: Binder<Bool> {
        return Binder(base) { view, hidden in
            UIView.animate(withDuration: 0.2) {
                view.isHidden = hidden
                view.superview?.layoutIfNeeded()
            }
        }
    }
}

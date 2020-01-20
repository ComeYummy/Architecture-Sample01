//
//  Driver+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift

extension Driver {
    /// ObservableTypeにのみ適合する `take(_:)` のDriver拡張。
    /// `ObservableType.take(_:)` にて用いられる TimerCount クラスがfinal privateのため，asObservable()して利用する。
    func take(_ count: Int, onErrorRecover: @escaping (Error) -> SharedSequence<DriverSharingStrategy, Element> = { _ in Driver<Element>.never() }) -> Driver<Element> {
        return asObservable().take(count).asDriver(onErrorRecover: onErrorRecover)
    }
}

//
//  ArrayTracker.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ArrayTracker<T>: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _array = BehaviorRelay<[T]>(value: [])

    var array: [T] {
        _array.value
    }

    func trackArray<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> where O.Element == [T] {
        source.asObservable().do(onNext: onNext)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, [T]> {
        _array.asObservable().asDriver(onErrorJustReturn: [])
    }

    func asObservable() -> Observable<[T]> {
        _array.asObservable()
    }

    private func onNext(_ array: [T]) {
        _array.accept(array)
    }

    deinit {
        _array.accept([])
    }
}

extension ObservableConvertibleType {
    func trackArray<T>(_ arrayTracker: ArrayTracker<T>) -> Observable<Element> where Element == [T] {
         arrayTracker.trackArray(from: self)
    }
}

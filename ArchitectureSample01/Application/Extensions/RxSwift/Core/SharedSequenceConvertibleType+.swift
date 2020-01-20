//
//  SharedSequenceConvertibleType+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift

extension SharedSequenceConvertibleType {
    /// Map from any to void
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }

    func mapToOptional() -> SharedSequence<SharingStrategy, Element?> {
        return map { Optional($0) }
    }

    func mapToTrue() -> SharedSequence<SharingStrategy, Bool> {
        return map { _ in true }
    }

    func mapToFalse() -> SharedSequence<SharingStrategy, Bool> {
        return map { _ in false }
    }

    func unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return filter { $0 != nil }.map { $0! }
    }
}

//
//  ObservableType+Rx.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        self.map(!)
    }

}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        catchError { _ in
            Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
//            assertionFailure("Error \(error)")
            Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}

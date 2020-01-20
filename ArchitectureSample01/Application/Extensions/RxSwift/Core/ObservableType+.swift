//
//  ObservableType+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
    func neverComplete() -> Observable<Element> {
        return concat(Observable.never())
    }

    /// エラーをnilに変換するオペレータ
    /// Nukeに渡した非同期UIImageがfailした際，UITableViewCellの再描画によってUIIamgeViewが不適切な値を参照してしまうのを防ぐ。
    func onErrorToNil() -> Observable<Element?> {
        return map { Optional($0) }
            .catchError { _ in
                return Observable.just(nil)
            }
    }

    func onErrorNeverComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.never()
        }
    }

    /// Map from any to void
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func mapToOptional() -> Observable<Element?> {
        return map { Optional($0) }
    }

    func mapToTrue() -> Observable<Bool> {
        return map { _ in true }
    }

    func mapToFalse() -> Observable<Bool> {
        return map { _ in false }
    }

    func toggle(startWith: Bool = false) -> Observable<Bool> {
        return scan(!startWith) { flag, _ in !flag }
    }

    /// Observable Current and Previous Value
    func withPrevious(startWith element: Element? = nil) -> Observable<(previous: Element, current: Element)> {
        return scan((element, element)) { ($0.1, $1) }
            .filter { $0.0 != nil && $0.1 != nil }.map { ($0.0!, $0.1!) }
    }

    func unwrap<T>() -> Observable<T> where Element == T? {
        return filter { $0 != nil }.map { $0! }
    }

    func subscribeOnConcurrentGlobalDispatch() -> Observable<Element> {
        return subscribeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
    }

    func catchErrorJustComplete() -> Observable<Element> {
        catchError { _ in
            Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
            return Driver.empty()
        }
    }

    func asDriverOnErrorNeverComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.never()
        }
    }
}

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        self.map(!)
    }

}

//
//  PrimitiveSequence+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift

public extension PrimitiveSequence {

    /**
     Projects each element of an single sequence into a new form.

     - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)

     - parameter transform: A transform function to apply to each source element.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source.

     */
    func map<R>(_ transform: @escaping (PrimitiveSequence.Element) throws -> R) -> RxSwift.Single<R> {
        return asObservable().map(transform).asSingle()
    }

    /**
     Projects each element of an single sequence to an single sequence and merges the resulting single sequences into one single sequence.

     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)

     - parameter selector: A transform function to apply to each element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<O>(_ selector: @escaping (PrimitiveSequence.Element) throws -> O) -> RxSwift.Single<O.Element> where O: ObservableConvertibleType {
        return asObservable().flatMap(selector).asSingle()
    }

    /**
     Convert any Observable into an Observable of its events.
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     - returns: An observable sequence that wraps events in an Event<E>. The returned Observable never errors, but it does complete after observing all of the events of the underlying Observable.
     */
    func materialize() -> RxSwift.Single<RxSwift.Event<PrimitiveSequence.Element>> {
        return asObservable().materialize().take(1).asSingle()
    }

    func mapToOptional() -> RxSwift.Single<PrimitiveSequence.Element?> {
        return map { Optional($0) }
    }
}

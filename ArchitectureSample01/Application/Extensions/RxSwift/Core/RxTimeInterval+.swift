//
//  RxTimeInterval+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/19.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import RxSwift

extension RxTimeInterval {
    static func seconds(_ value: Double) -> RxTimeInterval {
        return RxTimeInterval.milliseconds(Int(value * 1000))
    }
}

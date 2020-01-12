//
//  Exception.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation

enum Exception: Error {
    case network
    case auth
    case server
    case generic(message: String)
    case unknown
}

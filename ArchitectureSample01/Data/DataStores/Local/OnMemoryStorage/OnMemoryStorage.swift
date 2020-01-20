//
//  OnMemoryStorage.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation

class OnMemoryStorage {
    static let shared = OnMemoryStorage()

    private init() {}

//    var launchOptions: [UIApplication.LaunchOptionsKey: Any] = [:]

    private var cache: [String: Any] = [:]

    func get(key: String) -> Any? {
        return cache[key]
    }

    func set(key: String, value: Any) {
        cache[key] = value
    }

    func remove(key: String) {
        cache[key] = nil
    }
}

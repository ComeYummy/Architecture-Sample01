//
//  KeychainStorage.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import KeychainAccess

class KeychainStorage {
    lazy var keychain = Keychain()

    func get(key: String) -> String? {
        return keychain[key]
    }

    func set(key: String, value: String) {
        keychain[key] = value
    }

    func remove(key: String) {
        keychain[key] = nil
    }
}

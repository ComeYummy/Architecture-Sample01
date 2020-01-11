//
//  UINavigationItem+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/11.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

extension UINavigationItem {
    // 戻るボタンのタイトルを削除
    func removeBackBarButtonTitle() {
        backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
}

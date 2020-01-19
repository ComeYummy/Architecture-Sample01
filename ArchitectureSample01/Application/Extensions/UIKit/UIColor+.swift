//
//  UIColor+.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

// MARK: - System colors

extension UIColor {
    enum System {
        /// Default view background color
        static let backgroundColor = UIColor.hex(str: "E1E7ED")
        /// Default blue (e.g. tint color of UIButton)
        static let blue = UIColor.hex(str: "007AFF")
    }
}

// MARK: - Theme colors

extension UIColor {
    static let theme = UIColor.hex(str: "FFBD1B")
    static let themeTranslucent = theme.withAlphaComponent(0.10)

    static let customRed = UIColor.hex(str: "FF4876")
    static let customRedTranslucent = customRed.withAlphaComponent(0.04)
    static let customGreen = UIColor.hex(str: "50EFC6")
    static let customGreenTranslucent = customGreen.withAlphaComponent(0.04)
    static let customLightGreen = UIColor.hex(str: "50EFC6")

    static let customBlack = UIColor.hex(str: "33333D")
    static let customGrayDark = UIColor.hex(str: "A6B0BD")
    static let customGrayDarkTranslucent = customGrayDark.withAlphaComponent(0.51)
    static let customGray = UIColor.hex(str: "D0D6DE")
    static let customGrayLight = UIColor.hex(str: "EAEEF3")

    static let textDark = customBlack
    static let textLight = customGrayDark
    static let textGray = UIColor.hex(str: "7B8A9D")

    static let selectedGray = UIColor.hex(str: "d9d9d9")
}

extension UIColor {
    class func color(integer: Int, alpha: CGFloat = 1) -> UIColor {
        UIColor(red: CGFloat((integer & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((integer & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(integer & 0x0000FF) / 255.0,
                alpha: alpha)
    }

    class func hex(str hexStr: String, alpha: CGFloat = 1) -> UIColor {
        let hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let red = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }

    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

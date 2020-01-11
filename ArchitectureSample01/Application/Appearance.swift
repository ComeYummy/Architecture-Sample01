//
//  Appearance.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

struct Appearance {

    static let navigationBarTintColor = UIColor.customBlack
    static let navigationBarTitleColor = UIColor.customBlack
    static let navigationBarBarTintColor = UIColor.white

    static let normalColor = UIColor.customBlack
    static let highLightedAlpha: CGFloat = 0.5
    static let disabledAlpha: CGFloat = 0.5
    static let highlightedColor = UIColor.customBlack.withAlphaComponent(highLightedAlpha)
    static let disabledColor = UIColor.customBlack.withAlphaComponent(disabledAlpha)

    static func setup() {
        // tabbar
        UITabBar.appearance().tintColor = .customBlack

        // navbar
        //        let backImage = UIImage.VALU.Navigation.back
        //        UIGraphicsBeginImageContextWithOptions(CGSize(width: backImage.size.width + 10, height: backImage.size.height), false, UIScreen.main.scale)
        //        backImage.draw(at: CGPoint(x: 10, y: 0))
        //        let newBackImage = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        UINavigationBar.appearance().backIndicatorImage = newBackImage
        //        UINavigationBar.appearance().backIndicatorTransitionMaskImage = newBackImage
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = navigationBarTintColor
        UINavigationBar.appearance().barTintColor = navigationBarBarTintColor
        UINavigationBar.appearance().titleTextAttributes = textAttributes(UIFont.systemFont(ofSize: 16), color: navigationBarTitleColor)

        // bar button item
        UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes(17, color: normalColor), for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes(17, color: highlightedColor), for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes(17, color: disabledColor), for: .disabled)

        // textview
        UITextView.appearance().tintColor = UIColor.theme
        UITextField.appearance().tintColor = UIColor.theme

    }

    static func textAttributes(_ size: CGFloat, color: UIColor? = nil, alignment: NSTextAlignment? = nil, lineHeightDelta: CGFloat = 0, style: NSMutableParagraphStyle? = nil, kerning: CGFloat = 0.8) -> [NSAttributedString.Key: Any] {
        textAttributes(UIFont.systemFont(ofSize: size),
                       color: color,
                       alignment: alignment,
                       lineHeightDelta: lineHeightDelta,
                       style: style,
                       kerning: kerning)
    }

    static func textAttributes(_ font: UIFont, color: UIColor? = nil, alignment: NSTextAlignment? = nil, lineHeightDelta: CGFloat = 0, style: NSMutableParagraphStyle? = nil, kerning: CGFloat = 0.8) -> [NSAttributedString.Key: Any] {
        var pstyle = style
        var attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.kern: kerning
        ]

        if let color = color {
            attrs[NSAttributedString.Key.foregroundColor] = color
        }

        if lineHeightDelta > 0 {
            if pstyle == nil {
                pstyle = NSMutableParagraphStyle()
            }
            pstyle?.minimumLineHeight = font.lineHeight + lineHeightDelta
            pstyle?.maximumLineHeight = font.lineHeight + lineHeightDelta
        }

        if let alignment = alignment {
            if pstyle == nil {
                pstyle = NSMutableParagraphStyle()
            }
            pstyle?.alignment = alignment
        }

        if let pstyle = pstyle {
            attrs[NSAttributedString.Key.paragraphStyle] = pstyle
        }

        return attrs
    }
}

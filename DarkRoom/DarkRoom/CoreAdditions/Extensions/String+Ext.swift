//
//  String+Ext.swift
//  word-guess
//
//  Created by Cary Miller on 3/25/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

public extension String {

    func formatted(height: Float, kerning: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = CGFloat(height)

        if attributedString.length > 0 {
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attributedString.length))

            attributedString.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSRange(location: 0, length: attributedString.length - 1))
        }

        return attributedString
    }
}

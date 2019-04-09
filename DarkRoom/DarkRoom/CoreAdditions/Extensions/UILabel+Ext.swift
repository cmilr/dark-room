//
//  UILabel+Ext.swift
//  word-guess
//
//  Created by Cary Miller on 3/25/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

extension UILabel {

    func transition(toString string: String) {
        UIView.transition(
            with: self,
            duration: 0.5,
            options: [.transitionCrossDissolve],
            animations: {
                self.text = string
        },
            completion: nil
        )
    }

    func transition(toAttributedString string: NSMutableAttributedString) {
        UIView.transition(
            with: self,
            duration: 0.5,
            options: [.transitionCrossDissolve],
            animations: {
                self.attributedText = string
        },
            completion: nil
        )
    }

    func formatAndDisplay(text string: String, withLineHeight height: Float, andKerning kerning: CGFloat) {

        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = CGFloat(height)

        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSRange(location: 0, length: attributedString.length - 1))

        self.attributedText = attributedString
    }
}

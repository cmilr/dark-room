//
//  UITextView+Ext.swift
//  DarkRoom
//
//  Created by Cary Miller on 4/8/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

extension UITextView {

    func formatAndDisplay(text string: String, withFont font: String = "System Font Regular", fontSize: CGFloat = 22, fontColor: UIColor = .white, lineHeight height: Float, kerning: CGFloat, alignment: NSTextAlignment = .left, indicatorStyle: UIScrollView.IndicatorStyle = .white  ) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = CGFloat(height)
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont(name: font, size: fontSize)!,
            NSAttributedString.Key.foregroundColor: fontColor,
            NSAttributedString.Key.kern: kerning
            ] as [NSAttributedString.Key : Any]
        attributedText = NSAttributedString(string: string, attributes: attributes)

        self.indicatorStyle = indicatorStyle
        setContentOffset(CGPoint.zero, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.flashScrollIndicators()
        }
    }
}

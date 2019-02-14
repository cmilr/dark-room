//
//  UILabel+Ext.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/14/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

extension UILabel {

   func setLineHeight(_ lineHeightMultiple: CGFloat = 0.0) {

      guard let labelText = self.text else { return }

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineHeightMultiple = lineHeightMultiple

      let attributedString:NSMutableAttributedString
      if let labelattributedText = self.attributedText {
         attributedString = NSMutableAttributedString(attributedString: labelattributedText)
      } else {
         attributedString = NSMutableAttributedString(string: labelText)
      }

      attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

      self.attributedText = attributedString
   }
}

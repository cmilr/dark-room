//
//  UIView+Ext.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/18/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

   func fadeIn(_ duration: TimeInterval = 1, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
      UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
         self.alpha = 0.85
      }, completion: completion)  }

   func fadeOut(_ duration: TimeInterval = 1, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
      UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
         self.alpha = 0
      }, completion: completion)
   }
}

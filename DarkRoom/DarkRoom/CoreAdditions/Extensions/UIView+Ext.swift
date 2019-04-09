//
//  UIView+Extension.swift
//
//  Created by Cary Miller on 3/1/18.
//  Copyright © 2018 Cary Miller. All rights reserved.
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
    
    func popInAnimation() {
        UIView.animate(
            withDuration: 0.45,
            delay: 0.2,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 10,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
            completion: { _ in
        }
        )
    }

    func negativePopInAnimation() {
        UIView.animate(
            withDuration: 0.45,
            delay: 0.2,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 10,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: -1, y: -1)
        },
            completion: { _ in
        }
        )
    }

    func popOutAnimation() {
        UIView.animate(
            withDuration: 0.10,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 20,
            options: .curveEaseOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
            completion: { _ in
        }
        )
        UIView.animate(
            withDuration: 0.30,
            delay: 0.15,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 10,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.alpha = 0.0
        },
            completion: { _ in
        }
        )
    }
}

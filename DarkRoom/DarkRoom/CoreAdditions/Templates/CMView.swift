//
//  CMView.swift
//
//  Created by Cary Miller on 3/28/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class CMView: UIView {

    /// Basic Properties
    let bgColor: UIColor = .white
    let cornerRadius: CGFloat = 0
    let borderWidth: CGFloat = 0
    let borderColor: UIColor = .gray

    /// Shadow Properties
    let hasShadow: Bool = false
    let shadowColor: CGColor = UIColor.black.cgColor
    let shadowOpacity: Float = 0.7
    let shadowOffset: CGSize = CGSize(width: 7, height: 7)
    let shadowRadius: CGFloat = 2.0

    /// Gradient Properties
    let hasGradient: Bool = false
    let colorOne: CGColor = UIColor.blue.cgColor
    let colorTwo: CGColor = UIColor.red.cgColor
    let locations: [NSNumber] = [0.3, 0.7]
    let startPoint: CGPoint = CGPoint(x: 0.3, y: 0)
    let endPoint: CGPoint = CGPoint(x: 0.7, y: 1)

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = bgColor
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        if hasShadow {
            layer.masksToBounds = false
            layer.shadowColor = shadowColor
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
        }
    }

    override func layoutSubviews() {
        if hasGradient {
            layer.masksToBounds = true
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = [colorOne, colorTwo]
            gradient.locations = locations
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
            self.layer.insertSublayer(gradient, at: 0)
            if hasShadow {
                Log.warning("Can not satisfy both gradient and shadow requirements. Consider moving shadow to a separate view object.")
            }
        }
        super.layoutSubviews()
    }
}

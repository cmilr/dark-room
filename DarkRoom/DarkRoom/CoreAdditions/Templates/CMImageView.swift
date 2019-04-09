//
//  CMImageView.swift
//
//  Created by Cary Miller on 4/8/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class CMImageView: UIImageView {

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
}

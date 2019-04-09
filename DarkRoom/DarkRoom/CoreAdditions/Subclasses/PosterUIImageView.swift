//
//  PosterUIImageView.swift
//  DarkRoom
//
//  Created by Cary Miller on 4/7/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

public class PosterUIImageView: UIImageView {

    /// Basic Properties
    let bgColor: UIColor = .clear
    let cornerRadius: CGFloat = 0
    let borderWidth: CGFloat = 0
    let borderColor: UIColor = .gray

    /// Shadow Properties
    let hasShadow: Bool = true
    let shadowColor: CGColor = UIColor.black.cgColor
    let shadowOpacity: Float = 0.4
    let shadowOffset: CGSize = CGSize(width: 6, height: 6)
    let shadowRadius: CGFloat = 10.0

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

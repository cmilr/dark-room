//
//  CMButton.swift
//
//  Created by Cary Miller on 3/26/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class CMButton: UIButton {

    /// Text Properties
    var horizontalInsets: CGFloat = 5.0
    var verticalInsets: CGFloat = 5.0

    /// Basic Properties
    let bgColor: UIColor = .white
    let cornerRadius: CGFloat = 20
    let borderWidth: CGFloat = 3.0
    let borderColor: UIColor = .gray

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = bgColor
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        contentEdgeInsets = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    }
}

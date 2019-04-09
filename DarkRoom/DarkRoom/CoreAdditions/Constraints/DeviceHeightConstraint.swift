//
//  DeviceHeightConstraint.swift
//
//  Created by Cary Miller on 3/22/19.
//  Copyright © 2019 Cary Miller. All rights reserved.
//

import UIKit

class DeviceHeightConstraint: NSLayoutConstraint {

    /// iPhone SE & iPhone 5 Models
    @IBInspectable var small: CGFloat = 0

    /// All other numeric iPhone Models
    @IBInspectable var medium: CGFloat = 0

    /// All X-based iPhone Models
    @IBInspectable var large: CGFloat = 0

    /// All iPad Models
    @IBInspectable var xlarge: CGFloat = 0

    var screenSize: (width: CGFloat, height: CGFloat) {
        return (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }

    var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure() {
        switch screenSize.height {
        case DeviceHeightClass.small:
            constant = small
        case DeviceHeightClass.medium:
            constant = medium
        case DeviceHeightClass.large:
            constant = large
        case DeviceHeightClass.xlarge:
            constant = xlarge
        default:
            constant = medium
        }
    }
}

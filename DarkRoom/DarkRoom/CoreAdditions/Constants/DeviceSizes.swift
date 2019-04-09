//
//  DeviceSizes.swift
//
//  Created by Cary Miller on 3/1/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import CoreGraphics

class DeviceWidth {
    static let iPhoneSE: CGFloat = 320
    static let iPhone6: CGFloat = 375
    static let iPhone6Plus: CGFloat = 414
    static let iPhoneX: CGFloat = 375
    static let iPhoneXR: CGFloat = 413
    static let iPad: CGFloat = 768
    static let iPadPro2Small: CGFloat = 834
    static let iPadPro1And2: CGFloat = 1024
}

class DeviceHeight {
    static let iPhoneSE: CGFloat = 568
    static let iPhone6: CGFloat = 667
    static let iPhone6Plus: CGFloat = 736
    static let iPhoneNumeric: CGFloat = 736
    static let iPhoneX: CGFloat = 812
    static let iPhoneXR: CGFloat = 896
    static let iPad: CGFloat = 1024
    static let iPadPro2Small: CGFloat = 1112
    static let iPadPro1And2: CGFloat = 1366
}

class DeviceHeightClass {
    static let small = CGFloat.leastNormalMagnitude...DeviceHeight.iPhoneSE
    static let medium = (DeviceHeight.iPhoneSE + 1)...DeviceHeight.iPhoneNumeric
    static let large = (DeviceHeight.iPhoneNumeric + 1)...DeviceHeight.iPhoneXR
    static let xlarge = (DeviceHeight.iPhoneXR + 1)...CGFloat.greatestFiniteMagnitude
}

//
//  CustomColor.swift
//
//  Created by Cary Miller on 3/16/19.
//  Copyright © 2019 Cary Miller. All rights reserved.
//

import UIKit

enum CustomColor: String {
    case aqua
    case aquaLight
    case purple
    case purpleLight
    case purpleMedium
    case purpleDark
}

extension UIColor {
    static func custom(_ name: CustomColor) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            Log.warning("Returning .black: name could not be found in CustomColor enum")
            return .black
        }
        return color
    }
}

extension CGColor {
    static func custom(_ name: CustomColor) -> CGColor {
        return UIColor(named: name.rawValue)?.cgColor ?? UIColor.black.cgColor
    }
}

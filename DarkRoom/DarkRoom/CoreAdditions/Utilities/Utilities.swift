//
//  Utilities.swift
//
//  Created by Cary Miller on 2/22/18.
//  Copyright © 2018 Cary Miller. All rights reserved.
//

import UIKit

public func delayFor(seconds: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: .now() + seconds,
        execute: closure)
}

public func numDaysElapsed(from previous: Date, to current: Date) -> Int {
    let calendar = Calendar.current
    let date1 = calendar.startOfDay(for: previous)
    let date2 = calendar.startOfDay(for: current)
    let components = calendar.dateComponents([Calendar.Component.day], from: date1, to: date2)
    return components.day ?? 0
}

//
//  Logger.swift
//  RESTClient
//
//  Created by Cary Miller on 3/12/19.
//  Copyright © 2019 Cary Miller. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case error = "🛑"
    case info = "💬"
    case debug = "🤖"
    case verbose = "🗣"
    case warning = "⚠️"
    case severe = "🔥"
}

class Log {

    private static var loggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    class func error( _ object: Any, filename: String = #file) {
        if loggingEnabled {
            print(" \(LogEvent.error.rawValue) \(sourceFileName(filePath: filename)): \(object)")
        }
    }

    class func info( _ object: Any, filename: String = #file) {
        if loggingEnabled {
            print(" \(LogEvent.info.rawValue) \(sourceFileName(filePath: filename)): \(object)")
        }
    }

    class func debug( _ object: Any, filename: String = #file) {
        if loggingEnabled {
            print(" \(LogEvent.debug.rawValue) \(sourceFileName(filePath: filename)): \(object)")
        }
    }

    class func verbose( _ object: Any, filename: String = #file) {
        if loggingEnabled {
            print(" \(LogEvent.verbose.rawValue) \(sourceFileName(filePath: filename)): \(object)")
        }
    }

    class func warning( _ object: Any, filename: String = #file) {
        if loggingEnabled {
            print(" \(LogEvent.warning.rawValue) \(sourceFileName(filePath: filename)): \(object)")
        }
    }

    class func severe( _ object: Any, filename: String = #file) {
        if loggingEnabled {
            print(" \(LogEvent.severe.rawValue) \(sourceFileName(filePath: filename)): \(object)")
        }
    }

    class func networkInfo(_ request: URLRequest) {
        if loggingEnabled {
            print(" 🚌 {\(request.httpMethod!)} \(request)")
            print(" 🚚 Headers: \(request.allHTTPHeaderFields!)")
            switch request.httpMethod! {
            case "POST", "PUT":
                print(" 🚎 Request Body: \(request.httpBody!)")
            default:
                break
            }
        }
    }

    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

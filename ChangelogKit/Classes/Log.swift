//
//  Log.swift
//  ChangelogKit
//
//  Created by David Seek on 3/13/21.
//

import Foundation
import os.log

class Log {
    
    /// https://www.avanderlee.com/workflow/oslog-unified-logging/
    /// `default`
    /// `info`
    /// `debug`
    /// `error`
    /// `fault`
    
    public static func info(_ message: String) {
        os_log("%{public}@", type: .info, message)
    }
    
    public static func error(_ message: String) {
        os_log("%{public}@", type: .error, message)
    }
}

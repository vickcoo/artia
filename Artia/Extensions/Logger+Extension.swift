//
//  Logger+Extension.swift
//  Artia
//
//  Created by Vick on 3/29/25.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// A logger for general application logging.
    ///
    /// Use this logger to record general information about the application's
    /// operation. This can include user actions, application state changes,
    /// and other non-specific events.
    static let general = Logger(subsystem: subsystem, category: "general")

    /// A logger for network-related logging.
    ///
    /// Use this logger to record information about network requests, responses,
    /// and errors. This can help in diagnosing network issues and monitoring
    /// network activity.
    static let network = Logger(subsystem: subsystem, category: "network")

    /// A logger for storage-related logging.
    ///
    /// Use this logger to record information about data storage operations,
    /// such as data saving, fetching, and errors. This can help in diagnosing
    /// issues related to data storage.
    static let storage = Logger(subsystem: subsystem, category: "storage")
}

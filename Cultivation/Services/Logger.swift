import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.cultivation.app"

    static let app = Logger(subsystem: subsystem, category: "app")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let scanner = Logger(subsystem: subsystem, category: "scanner")
    static let garden = Logger(subsystem: subsystem, category: "garden")
}

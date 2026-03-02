import Foundation

struct WeatherInfo {
    let locationName: String
    let zone: String
    let condition: WeatherCondition
    let temperatureFahrenheit: Int
    let suppressOutdoorWatering: Bool
    let suppressDays: Int
    let forecastSummary: String

    enum WeatherCondition {
        case clear, cloudy, rain, storm

        var icon: String {
            switch self {
            case .clear: return "sun.max.fill"
            case .cloudy: return "cloud.fill"
            case .rain: return "cloud.rain.fill"
            case .storm: return "cloud.bolt.rain.fill"
            }
        }
    }
}

struct WeatherService {
    static func currentWeather() -> WeatherInfo {
        WeatherInfo(
            locationName: "Daphne, AL",
            zone: "Zone 8b",
            condition: .rain,
            temperatureFahrenheit: 74,
            suppressOutdoorWatering: true,
            suppressDays: 3,
            forecastSummary: "Heavy rain expected tomorrow. Outdoor watering paused for 3 days."
        )
    }
}

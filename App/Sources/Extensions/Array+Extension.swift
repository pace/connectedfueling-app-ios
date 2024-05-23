import Foundation
import PACECloudSDK

extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

extension Array where Element == (POIKit.OpeningHoursValue, POIKit.OpeningHoursValue) {
    func toReadableStrings() -> [(String, String)] {
        return lazy.map { day, time in (day.toString(), time.toString()) }
    }
}

extension POIKit.OpeningHoursValue {
    func toString() -> String {
        switch self {
        case .open247, .wholeDay:
            return L10n.gasStationOpeningHoursAlwaysOpen

        case .closed:
            return L10n.gasStationOpeningHoursClosed

        case .daily:
            return L10n.gasStationOpeningHoursDaily

        case .weekday(let from, let to):
            return getLocalizedWeekDay(weekday: from) + " – " + getLocalizedWeekDay(weekday: to)

        case .day(let day):
            return getLocalizedWeekDay(weekday: day)

        case .time(let value):
            return value
        }
    }

    func getLocalizedWeekDay(weekday: String) -> String {
        switch weekday {
        case "monday":
            return L10n.commonUseMonday

        case "tuesday":
            return L10n.commonUseTuesday

        case "wednesday":
            return L10n.commonUseWednesday

        case "thursday":
            return L10n.commonUseThursday

        case "friday":
            return L10n.commonUseFriday

        case "saturday":
            return L10n.commonUseSaturday

        case "sunday":
            return L10n.commonUseSunday

        default:
            return ""
        }
    }
}

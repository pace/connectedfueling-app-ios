// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import Foundation
import PACECloudSDK

/// GasStation opening hours
struct OpeningHours: POIModelConvertible, CustomStringConvertible {
    /// a list of days where this rule applies
    let days: [Days]

    /// a list of opening hour ranges
    let hours: [OpeningHour]

    /// open or closed
    let rule: OpeningRule?

    init(days: [Days], hours: [OpeningHour], rule: OpeningRule?) {
        self.days = days
        self.hours = hours
        self.rule = rule
    }

    init(from openingHours: PCPOICommonOpeningHours.Rules) {
        let days = openingHours.days?.map { Days(from: $0) } ?? []
        let hours = openingHours.timespans?.compactMap({ OpeningHour(from: $0) }) ?? []

        var openingRule: OpeningRule?
        if let poiRule = openingHours.action {
            openingRule = OpeningRule(from: poiRule)
        }

        self.days = days
        self.hours = hours
        self.rule = openingRule
    }

    func poiConverted() -> PCPOICommonOpeningHours.Rules {
        let poiDays = days.map { $0.poiConverted() }
        let timespans = hours.map { $0.poiConverted() }
        let action = rule?.poiConverted()
        return PCPOICommonOpeningHours.Rules(action: action, days: poiDays, timespans: timespans)
    }

    var description: String {
        return "\(days.map { $0.rawValue }): \(hours): \(rule?.rawValue ?? "-")"
    }
}

/// GasStation opening rule
enum OpeningRule: String, POIModelConvertible {
    /// open
    case open
    /// closed
    case closed

    init(from rule: PCPOICommonOpeningHours.Rules.PCPOIAction) {
        switch rule {
        case .open:
            self = .open

        default:
            self = .closed
        }
    }

    func poiConverted() -> PCPOICommonOpeningHours.Rules.PCPOIAction {
        switch self {
        case .open:
            return PCPOICommonOpeningHours.Rules.PCPOIAction.open

        case .closed:
            return PCPOICommonOpeningHours.Rules.PCPOIAction.close
        }
    }
}

/// WeekDays for GasStation OpeningHours
enum Days: String, CaseIterable, POIModelConvertible {
    /// monday
    case monday = "mo"
    /// tuesday
    case tuesday = "tu"
    /// wednesday
    case wednesday = "we"
    /// thursday
    case thursday = "th"
    /// friday
    case friday = "fr"
    /// saturday
    case saturday = "sa"
    /// sunday
    case sunday = "su"

    static var weekdays: [Days] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    static var weekend: [Days] = [.saturday, .sunday]

    init(from day: PCPOICommonOpeningHours.Rules.PCPOIDays) {
        switch day {
        case .monday:
            self = .monday

        case .tuesday:
            self = .tuesday

        case .wednesday:
            self = .wednesday

        case .thursday:
            self = .thursday

        case .friday:
            self = .friday

        case .saturday:
            self = .saturday

        default:
            self = .sunday
        }
    }

    func poiConverted() -> PCPOICommonOpeningHours.Rules.PCPOIDays {
        switch self {
        case .monday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.monday

        case .tuesday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.tuesday

        case .wednesday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.wednesday

        case .thursday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.thursday

        case .friday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.friday

        case .saturday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.saturday

        case .sunday:
            return PCPOICommonOpeningHours.Rules.PCPOIDays.sunday
        }
    }
}

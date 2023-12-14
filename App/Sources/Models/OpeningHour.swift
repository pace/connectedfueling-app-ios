// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import Foundation
import PACECloudSDK

/// opening hour range
struct OpeningHour: CustomStringConvertible {
    /// opening time, format: hh:mm, minutes are omitted if :00
    let from: String

    /// closing time, format: hh:mm, minutes are omitted if :00
    let to: String

    init(from: String, to: String) {
        self.from = from
        self.to = to
    }

    init(from openingHour: PCPOICommonOpeningHours.Rules.Timespans) {
        self.from = openingHour.from ?? ""
        self.to = openingHour.to ?? ""
    }

    func poiConverted() -> PCPOICommonOpeningHours.Rules.Timespans {
        PCPOICommonOpeningHours.Rules.Timespans(from: from, to: to)
    }

    var description: String {
        return "From \(from) to \(to)"
    }
}

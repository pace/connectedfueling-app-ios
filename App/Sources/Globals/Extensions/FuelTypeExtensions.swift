// Copyright © 2022 PACE Telematics GmbH. All rights reserved.

import Foundation
import Domain

extension FuelType {
    func localizedDescription() -> String {
        switch self {
        case .diesel:
            return L10n.FuelType.diesel

        case .ron95e5:
            return L10n.FuelType.super

        case .ron95e10:
            return L10n.FuelType.superE10

        case .ron98e5:
            return L10n.FuelType.superPlus
        }
    }
}

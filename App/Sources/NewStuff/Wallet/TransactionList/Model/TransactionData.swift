// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import Foundation

struct TransactionData: Hashable {
    let timestamp: Date
    let price: Double
    let gasStationName: String
}

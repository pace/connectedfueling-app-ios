// Copyright © 2024 PACE Telematics GmbH. All rights reserved.

import PACECloudSDK

extension POIKit.GasStation {
    var country: String? {
        additionalProperties?["country"] as? String
    }
}

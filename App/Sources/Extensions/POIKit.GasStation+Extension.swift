import PACECloudSDK

extension POIKit.GasStation {
    var country: String? {
        additionalProperties?["country"] as? String
    }
}

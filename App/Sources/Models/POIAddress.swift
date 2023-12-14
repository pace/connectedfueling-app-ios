import Foundation
import PACECloudSDK

struct POIAddress: POIModelConvertible {
    /// Country Code, e.g. 'DE'
    let countryCode: String?

    /// City, e.g. 'Karlsruhe'
    let city: String?

    /// Zip Code, e.g. '76131'
    let zipCode: String?

    /// Suburb, e.g. 'Oststadt'
    let suburb: String?

    /// State, e.g. 'BW'
    let state: String?

    /// Street name, e.g. 'Haid-und-Neu-Straße'
    let street: String?

    /// House Number, e.h. '18'
    let houseNumber: String?

    init(countryCode: String?, city: String?, zipCode: String?, suburb: String?, state: String?, street: String?, houseNumber: String?) {
        self.countryCode = countryCode
        self.city = city
        self.zipCode = zipCode
        self.suburb = suburb
        self.state = state
        self.street = street
        self.houseNumber = houseNumber
    }

    init(from address: PCPOIGasStation.Address) {
        self.countryCode = address.countryCode
        self.city = address.city
        self.zipCode = address.postalCode
        self.street = address.street
        self.houseNumber = address.houseNo
        self.suburb = nil
        self.state = nil
    }

    func poiConverted() -> PCPOIGasStation.Address {
        PCPOIGasStation.Address(city: city,
                                countryCode: countryCode,
                                houseNo: houseNumber,
                                postalCode: zipCode,
                                street: street)
    }
}

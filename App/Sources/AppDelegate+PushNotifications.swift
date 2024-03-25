#if ANALYTICS

// According to this SO post (https://stackoverflow.com/a/32283844/12338765)
// Apple checks if `application:didRegisterForRemoteNotificationsWithDeviceToken` is implemented.
// If it is but there is no push notification entitlement, Apple sends out a warning mail when uploading a build to ASC.
// To prevent this warning mail, we'll only implement this delegate method if analytics are configured.

import UIKit

extension AppDelegate {
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        CofuLogger.e("[AppDelegate] Unable to register for remote notifications: \(error)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CofuLogger.i("[AppDelegate] Successfully registered for remote notifications")
    }
}

#endif

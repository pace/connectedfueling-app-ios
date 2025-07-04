// Copyright © 2025 PACE Telematics GmbH. All rights reserved.

import Foundation

enum PaginatedUIState<T> {
    case initialLoading
    case hasNextPage(T)
    case loadingNextPage(T)
    case loadedAllPages(T)
    case failure(T?, Error?)

    var isLoading: Bool {
        switch self {
        case .initialLoading, .loadingNextPage:
            return true

        default:
            return false
        }
    }
}

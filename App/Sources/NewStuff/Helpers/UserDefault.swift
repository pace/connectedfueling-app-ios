import Foundation

enum AppUserDefaults {
    static func value<T: Codable>(for key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
              let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }

        return value
    }

    static func set<T: Codable>(_ value: T, for key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

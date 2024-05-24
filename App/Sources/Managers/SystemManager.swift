import CryptoKit
import Foundation

enum SystemManager {
    static var languageCode: String {
        Locale.current.languageCode ?? Constants.fallbackLanguageCode
    }

    static func loadJSONFromBundle<T: Decodable>(fileName: String) -> T {
        let filePath = filePathInBundle(fileName: fileName, fileExtension: "json")

        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let fileContent = try JSONDecoder().decode(T.self, from: fileData)
            return fileContent
        } catch {
            fatalError("[SystemManager] Failed loading json \(fileName) from bundle with error \(error)")
        }
    }

    static func loadHTMLFromBundle(fileName: String) -> String {
        let filePath = filePathInBundle(fileName: fileName, fileExtension: "html")

        do {
            let htmlString = try String(contentsOfFile: filePath, encoding: .utf8)
            return htmlString
        } catch {
            fatalError("[SystemManager] Failed loading html \(fileName) from bundle with error \(error)")
        }
    }

    static func loadHTMLFromBundle(fileName: String, for locale: String) -> String {
        let filePath = filePathInBundle(fileName: fileName, fileExtension: "html", locale: locale)

        do {
            let htmlString = try String(contentsOfFile: filePath, encoding: .utf8)
            return htmlString
        } catch {
            fatalError("[SystemManager] Failed loading html \(fileName) from bundle with error \(error)")
        }
    }

    static func loadHTMLHashFromBundle(fileName: String, for locale: String) -> String {
        let url = urlInBundle(fileName: fileName, fileExtension: "html", locale: locale)

        do {
            let htmlData = try Data(contentsOf: url)
            let digest = Insecure.MD5.hash(data: htmlData)
            return digest.hashString
        } catch {
            fatalError("[SystemManager] Failed loading html \(fileName) from bundle with error \(error)")
        }
    }

    private static func filePathInBundle(fileName: String, fileExtension: String) -> String {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            fatalError("[SystemManager] Could not find file in Bundle: \(fileName).\(fileExtension)")
        }

        return filePath
    }

    private static func filePathInBundle(fileName: String, fileExtension: String, locale: String) -> String {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension, inDirectory: nil, forLocalization: locale) else {
            fatalError("[SystemManager] Could not find file in Bundle: \(fileName).\(fileExtension)")
        }

        return filePath
    }

    private static func urlInBundle(fileName: String, fileExtension: String, locale: String) -> URL {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension, subdirectory: nil, localization: locale) else {
            fatalError("[SystemManager] Could not find file in Bundle: \(fileName).\(fileExtension)")
        }

        return url
    }
}

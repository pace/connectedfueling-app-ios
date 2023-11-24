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

    private static func filePathInBundle(fileName: String, fileExtension: String) -> String {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            fatalError("[SystemManager] Could not find file in Bundle: \(fileName).\(fileExtension)")
        }

        return filePath
    }
}

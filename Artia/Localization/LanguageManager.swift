import Foundation
import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case chineseTraditional = "zh-Hant"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .chineseTraditional:
            return "繁體中文"
        }
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("app_language") var language: Language = {
        let preferredLanguages = Locale.preferredLanguages
        if let firstLanguage = preferredLanguages.first {
            if firstLanguage.starts(with: "zh-Hant") || firstLanguage.starts(with: "zh-TW") || firstLanguage.starts(with: "zh-HK") {
                return .chineseTraditional
            }
        }
        return .english
    }()

    private init() {}

    func setLanguage(_ language: Language) {
        self.language = language
    }
}

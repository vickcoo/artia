//
//  Tab.swift
//  Artia
//
//  Created by Vick on 4/1/25.
//


enum Tab: String {
    // User
    case missions
    case journey

    // Creator
    case creator
    
    var title: String {
        switch self {
        case .missions:
            return i18n.missions.localized
        case .journey:
            return i18n.journey.localized
        case .creator:
            return i18n.creator.localized
        }
    }
}

//
//  I18nKey.swift
//  Artia
//
//  Created by Vick on 3/19/25.
//

import Foundation

enum i18n: String {
    // MARK: - Tabs

    case missions
    case journey
    case creator

    // MARK: - Common

    case all
    case finish
    case cancel
    case add
    case info
    case title
    case description
    case content
    case create
    case save
    case delete
    case edit
    case back
    case next
    case done
    case settings
    case select

    case noMission
    case NoMissionInThisStory

    // MARK: - Mission Related

    case editMission
    case addMission
    case addCondition
    case addReward
    case createMission
    case selectMission
    case selectStory
    case reward
    case mainMission
    case sideMission
    case repeatMission

    // MARK: - Mission Types

    case missionType
    case main
    case side
    case `repeat`

    // MARK: - Story Related

    case story
    case createStory
    case editStory

    // MARK: - Conditions

    case conditions
    case imageCondition
    case xImages
    case healthCondition
    case healthCategory
    case goal

    // MARK: - Health Related

    case health
    case steps
    case calories
    case water
    case ml
    case type

    // MARK: - Images

    case image

    // MARK: - Language Settings

    case language
    case languageSettings
    case appLanguage
    case restartAppNotice

    // MARK: - Format Strings

    case itemAt

    var localized: String {
        return rawValue.localized
    }

    func localized(with arguments: CVarArg...) -> String {
        return String(format: rawValue.localized, arguments: arguments)
    }
}

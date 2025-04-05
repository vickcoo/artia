//
//  MissionsViewModel.swift
//  Artia
//
//  Created by Vick on 3/30/25.
//

import Foundation
import SwiftUI

final class MissionsViewModel: ObservableObject {
    private var store: MissionStore
    @Published var sheetType: MissionsSheetType? = nil
    @Published var selectedStoryId: UUID?
    @Published var selectedMissionId: UUID?

    init(store: MissionStore) {
        self.store = store
    }

    var mainMissions: [Mission] {
        currentMainMissionFilterByStory.filter {
            $0.type == .main && $0.status == .doing
        }
    }

    var sideMissions: [Mission] {
        missionsFilterByStory.filter {
            $0.type == .side
        }
    }

    var repeatMissions: [Mission] {
        missionsFilterByStory.filter {
            $0.type == .repeat
        }
    }

    var nextMissionFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            if let story = store.stories.first(where: { $0.id == selectedStoryId }) {
                return story.todoMissions
            } else {
                return []
            }
        } else {
            return store.stories.flatMap { $0.todoMissions }
        }
    }

    var missionsFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            return store.stories
                .first { $0.id == selectedStoryId }?.missions
                .filter { $0.status == .doing }
                ?? []
        } else {
            return store.stories.flatMap { $0.missions }
                .filter { $0.status == .doing }
        }
    }

    var hasAnyMissionAvailable: Bool {
        var missions: [Mission] = []
        if let selectedStoryId = selectedStoryId {
            missions = store.stories
                .first { $0.id == selectedStoryId }?.missions
                .filter { $0.status == .doing || $0.status == .todo }
                ?? []
        } else {
            missions = store.stories.flatMap { $0.missions }
                .filter { $0.status == .doing || $0.status == .todo }
        }

        return missions.isEmpty == false
    }

    var currentMainMissionFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            if let mission = store.stories.first(where: { $0.id == selectedStoryId })?.currentMainMissions {
                return [mission]
            } else {
                return []
            }
        } else {
            return store.stories.compactMap { $0.currentMainMissions }
        }
    }

    var nextMainMissionFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            if let mission = store.stories.first(where: { $0.id == selectedStoryId })?.nextMainMission {
                return [mission]
            } else {
                return []
            }
        } else {
            return store.stories.compactMap { $0.nextMainMission }
        }
    }

    var storyChipOptions: [ChipOption] {
        store.stories.map { ChipOption(id: $0.id, title: $0.title) }
    }

    func showSheet(_ type: MissionsSheetType) {
        DispatchQueue.main.async {
            self.sheetType = type
        }
    }
}

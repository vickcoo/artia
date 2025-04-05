//
//  EditMissionViewModel.swift
//  Artia
//
//  Created by Vick on 3/30/25.
//

import Foundation

final class EditMissionViewModel: ObservableObject {
    private var store: MissionStore
    @Published var mission: Mission

    @Published var title: String
    @Published var description: String
    @Published var selectedMissionType: MissionType
    @Published var selectedStory: Story?
    @Published var showingStoryPicker = false

    // Condition
    @Published var conditions: [any MissionCondition]
    @Published var showingAddCondition = false

    // Reward
    @Published var rewards: [MissionReward]
    @Published var showingAddReward = false

    init(store: MissionStore, mission: Mission, story: Story) {
        self.store = store
        self.mission = mission
        title = story.title
        description = story.content
        selectedMissionType = mission.type
        selectedStory = story
        conditions = mission.conditions
        rewards = mission.rewards
    }

    func saveMission() {
        guard let selectedStory else { return }

        let updatedMission = Mission(
            id: mission.id,
            title: title,
            description: description,
            status: mission.status,
            type: selectedMissionType,
            conditions: conditions,
            rewards: rewards
        )

        store.updateMission(mission: updatedMission, in: selectedStory)
    }
}

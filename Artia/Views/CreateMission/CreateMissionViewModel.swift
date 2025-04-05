//
//  CreateMissionViewModel.swift
//  Artia
//
//  Created by Vick on 3/30/25.
//

import Foundation

final class CreateMissionViewModel: ObservableObject {
    private var store: MissionStore
    
    @Published var title = ""
    @Published var description = ""
    @Published var selectedMissionType: MissionType = .main
    @Published var selectedStory: Story?
    @Published var showingStoryPicker = false

    // Condition
    @Published var conditions: [any MissionCondition] = []
    @Published var showingAddCondition = false

    // Reward
    @Published var rewards: [MissionReward] = []
    @Published var showingAddReward = false
    
    init(store: MissionStore) {
        self.store = store
    }
    
    func createMission() async {
        let newMission = Mission(
            title: title,
            description: description,
            status: .todo,
            type: selectedMissionType,
            conditions: conditions,
            rewards: rewards
        )

        Task {
            if let storyId = selectedStory?.id {
                store.addMission(mission: newMission, to: storyId)
            }
        }
    }
}

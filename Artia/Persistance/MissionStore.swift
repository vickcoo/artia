//
//  MissionStore.swift
//  Artia
//
//  Created by Vick on 3/11/25.
//

import Foundation

// MARK: Mission
class MissionStore: ObservableObject {
    @Published var stories: [Story] = MockData.stories
    @Published var selectedMission: Mission?

    func addMission(mission: Mission, to storyId: UUID) {
        if let index = stories.firstIndex(where: { $0.id == storyId }) {
            stories[index].missions.append(mission)
        }
    }

    func getAllMission() -> [Mission] {
        stories.flatMap { $0.missions }
    }

    func getMission(by id: UUID?) -> Mission? {
        stories.flatMap { $0.missions }.first { $0.id == id }
    }
}

// MARK: Story
extension MissionStore {
    func addStory(_ story: Story) {
        stories.append(story)
    }

    func getStory(by id: UUID?) -> Story? {
        stories.first { $0.id == id }
    }

    func getStory(by mission: Mission) -> Story? {
        stories.first(where: { $0.missions.contains(mission) })
    }

    func updateStory(_ story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index] = story
        }
    }

    func deleteStory(_ story: Story) {
        stories.removeAll { $0.id == story.id }
    }
}

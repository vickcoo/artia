//
//  MissionStore.swift
//  Artia
//
//  Created by Vick on 3/11/25.
//

import Foundation

class MissionStore: ObservableObject {
    @Published var stories: [Story] = []
    @Published var missions: [Mission] = MockData.tasks
    @Published var selectedMission: Mission?

    func createMission(_ mission: Mission) {
        DispatchQueue.main.async {
            self.missions.append(mission)
        }
    }

    func deleteMission(_ mission: Mission) async throws {
        missions.removeAll { $0.id == mission.id }
        if selectedMission?.id == mission.id {
            selectedMission = nil
        }
    }
    
    func deleteMission(_ index: IndexSet) async throws {
        // missions.remove(at: index)
    }

    func updateMission(_ mission: Mission) async throws {
        if let index = missions.firstIndex(where: { $0.id == mission.id }) {
            missions[index] = mission
            if selectedMission?.id == mission.id {
                selectedMission = mission
            }
        }
    }

    func addStory(_ story: Story) {
        stories.append(story)
    }

    func deleteStory(_ story: Story) {
        stories.removeAll { $0.id == story.id }
    }
}

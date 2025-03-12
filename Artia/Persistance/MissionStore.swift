//
//  MissionStore.swift
//  Artia
//
//  Created by Vick on 3/11/25.
//

import Foundation

class MissionStore: ObservableObject {
    @Published var missions: [Mission] = MockData.tasks
    @Published var selectedMission: Mission?

    func createMission(_ mission: Mission) async throws {
        missions.append(mission)
    }

    func deleteMission(_ mission: Mission) async throws {
        missions.removeAll { $0.id == mission.id }
        if selectedMission?.id == mission.id {
            selectedMission = nil
        }
    }

    func updateTask(_ mission: Mission) async throws {
        if let index = missions.firstIndex(where: { $0.id == mission.id }) {
            missions[index] = mission
            if selectedMission?.id == mission.id {
                selectedMission = mission
            }
        }
    }
}

//
//  Story.swift
//  Artia
//
//  Created by Vick on 3/15/25.
//

import Foundation

struct Story: Identifiable, Equatable {
    let id: UUID
    var title: String
    var content: String

    var missions: [Mission] = []

    init(id: UUID = UUID(), title: String, content: String, missions: [Mission] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.missions = missions
    }

    mutating func removeMission(by mission: Mission) {
        removeMission(by: mission.id)
    }

    mutating func removeMission(by id: UUID) {
        guard let missionIndex = missions.firstIndex(where: { $0.id == id }) else { return }
        missions.remove(at: missionIndex)
    }

    mutating func addMission(_ mission: Mission) {
        missions.append(mission)
    }
}

extension Story: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.id == rhs.id
    }
}

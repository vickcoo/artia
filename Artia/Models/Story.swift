//
//  Story.swift
//  Artia
//
//  Created by Vick on 3/15/25.
//

import Foundation

class Story: Identifiable, Equatable, ObservableObject {
    let id: UUID
    var title: String
    var content: String

    @Published var missions: [Mission] = []
    
    var currentMainMissions: Mission? {
        missions.first {
            $0.type == .main
            && $0.status == .doing
        }
    }

    init(id: UUID = UUID(), title: String, content: String, missions: [Mission] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.missions = missions
    }

    func removeMission(by mission: Mission) {
        removeMission(by: mission.id)
    }

    func removeMission(by id: UUID) {
        guard let missionIndex = missions.firstIndex(where: { $0.id == id }) else { return }
        missions.remove(at: missionIndex)
    }

    func addMission(_ mission: Mission) {
        missions.append(mission)
    }
    
    func moveMission(from source: IndexSet, to destination: Int) {
        print("\(missions.map({$0.title}))")
        missions.move(fromOffsets: source, toOffset: destination)
        print("\(missions.map({$0.title}))")
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

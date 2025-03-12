import Foundation
import SwiftUI

struct Mission: Identifiable, Equatable {
    let id: UUID = .init()
    let title: String
    let description: String
    let status: MissionStatus
    let type: MissionType
    let story: Story?
    var conditions: [MissionCondition]
    let rewards: [MissionReward]

    var isCompletedConditions: Bool {
        conditions.allSatisfy { $0.isCompleted }
    }

    var isUncompleted: Bool {
        conditions.contains(where: { $0.isCompleted == false })
    }
}

enum MissionStatus: String, Codable {
    case todo
    case done
}

enum MissionType: String, Codable {
    case main
    case side
    case `repeat`
}

struct MissionReward: Identifiable, Equatable {
    let id: UUID = .init()
    let title: String
    let description: String
}

struct Story: Identifiable, Equatable {
    let id: UUID = .init()
    var title: String
    var content: String
}

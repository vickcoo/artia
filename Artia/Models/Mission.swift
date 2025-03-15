import Foundation
import SwiftUI

final class Mission: Identifiable, ObservableObject {
    let id: UUID
    let title: String
    let description: String
    let status: MissionStatus
    let type: MissionType
    let storyId: UUID?
    @Published var conditions: [any MissionCondition]
    let rewards: [MissionReward]

    init(id: UUID = UUID(), title: String, description: String, status: MissionStatus, type: MissionType, storyId: UUID?, conditions: [any MissionCondition], rewards: [MissionReward]) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.type = type
        self.storyId = storyId
        self.conditions = conditions
        self.rewards = rewards
    }
    
    var isCompleted: Bool {
        conditions.allSatisfy { $0.isCompleted() }
    }
}

extension Mission: Equatable {
    static func == (lhs: Mission, rhs: Mission) -> Bool {
        lhs.id == rhs.id
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
    
    var text: String {
        switch self {
        case .main:
            return "Main"
        case .side:
            return "Side"
        case .repeat:
            return "Repeat"
        }
    }
    
    var color: Color {
        switch self {
        case .main:
            return .mainTaskYellow
        case .side:
            return .sideTaskBlue
        case .repeat:
            return .repeatTaskGreen
        }
    }
}

struct MissionReward: Identifiable, Equatable {
    let id: UUID = .init()
    let title: String
    let description: String
}

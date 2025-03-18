import Foundation
import SwiftUI

final class Mission: Identifiable, ObservableObject {
    let id: UUID
    let title: String
    let description: String
    @Published var status: MissionStatus
    let type: MissionType
    @Published var conditions: [any MissionCondition]
    let rewards: [MissionReward]

    init(id: UUID = UUID(), title: String, description: String, status: MissionStatus, type: MissionType, conditions: [any MissionCondition], rewards: [MissionReward]) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.type = type
        self.conditions = conditions
        self.rewards = rewards
    }

    func finish() { status = .done }

    var isCompleted: Bool { status == .done }

    var isUncompleted: Bool { !isCompleted }

    var canCompleted: Bool { conditions.allSatisfy { $0.isCompleted() } }

    var canNotCompleted: Bool { !canCompleted }
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

enum MissionType: String, Codable, Identifiable {
    var id: String { rawValue }
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

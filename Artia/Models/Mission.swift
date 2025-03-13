import Foundation
import SwiftUI

class Mission: Identifiable, ObservableObject {
    let id: UUID = .init()
    let title: String
    let description: String
    let status: MissionStatus
    let type: MissionType
    let story: Story?
    var conditions: [any MissionCondition]
    let rewards: [MissionReward]

    @Published var isCompleted: Bool = false

    init(title: String, description: String, status: MissionStatus, type: MissionType, story: Story?, conditions: [any MissionCondition], rewards: [MissionReward]) {
        self.title = title
        self.description = description
        self.status = status
        self.type = type
        self.story = story
        self.conditions = conditions
        self.rewards = rewards
    }

    func updateCompleted() {
        isCompleted = conditions.allSatisfy { $0.isCompleted() }
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

struct Story: Identifiable, Equatable {
    let id: UUID = .init()
    var title: String
    var content: String
    var missions: [Mission]
}

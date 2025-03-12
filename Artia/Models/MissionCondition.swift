//
//  MissionCondition.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import Foundation
import SwiftUI

class MissionCondition: Identifiable, ObservableObject {
    let id: UUID = .init()
    let title: String
    private(set) var strategy: ConditionStrategy

    init(title: String, strategy: ConditionStrategy) {
        self.title = title
        self.strategy = strategy
    }

    var isCompleted: Bool {
        return strategy.isCompleted()
    }

    var type: MissionConditionType {
        return strategy.type
    }

    var goal: Double {
        return strategy.goal
    }

    func setValue(_ value: Any) {
        strategy.setValue(value)
    }

    func getValue() -> Any {
        return strategy.getValue()
    }
}

extension MissionCondition: Equatable {
    static func == (lhs: MissionCondition, rhs: MissionCondition) -> Bool {
        lhs.id == rhs.id
    }
}

enum HealthKitConditionType: Codable, Equatable {
    case steps
    case calories
    case water
}

enum MissionConditionType: Codable, Equatable {
    case image
    case healthKit
}

protocol ConditionStrategy {
    var type: MissionConditionType { get }
    var goal: Double { get }
    func isCompleted() -> Bool

    func getValue() -> Any
    mutating func setValue(_ value: Any)
}

class ImageConditionStrategy: ConditionStrategy {
    let type: MissionConditionType = .image
    let goal: Double
    var images: [UIImage]

    init(goal: Double, images: [UIImage]) {
        self.goal = goal
        self.images = images
    }

    func isCompleted() -> Bool {
        return Double(images.count) >= goal
    }

    func getValue() -> Any {
        return images
    }

    func setValue(_ value: Any) {
        if let newImages = value as? [UIImage] {
            images = newImages
        }
    }
}

class HealthKitConditionStrategy: ConditionStrategy {
    let type: MissionConditionType = .healthKit
    let goal: Double
    let healthType: HealthKitConditionType
    var progress: Double

    init(goal: Double, healthType: HealthKitConditionType, progress: Double) {
        self.goal = goal
        self.healthType = healthType
        self.progress = progress
    }

    func isCompleted() -> Bool {
        switch healthType {
        case .steps:
            return progress >= goal
        case .calories:
            return progress >= goal
        case .water:
            return progress >= goal
        }
    }

    func getValue() -> Any {
        return progress
    }

    func setValue(_ value: Any) {
        if let newProgress = value as? Double {
            progress = newProgress
        }
    }
}

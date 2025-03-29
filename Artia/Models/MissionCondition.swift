//
//  MissionCondition.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import Foundation
import SwiftUI

protocol MissionCondition: Identifiable, ObservableObject {
    associatedtype ValueType

    var id: UUID { get }
    var type: MissionConditionType { get set }
    var title: String { get set }
    var value: ValueType { get set }
    var goal: Double { get set }

    func isCompleted() -> Bool
}

class AnyMissionCondition: Identifiable, ObservableObject {
    private var _getValue: () -> Any
    private var _setValue: (Any) -> Void

    private var _getGoal: () -> Double
    private var _setGoal: (Double) -> Void

    private var _getTitle: () -> String
    private var _setTitle: (String) -> Void

    private var _getType: () -> MissionConditionType
    private var _setType: (MissionConditionType) -> Void

    private var _getIsCompleted: () -> Bool

    @Published var value: Any {
        didSet { _setValue(value) }
    }

    @Published var goal: Double {
        didSet { _setGoal(goal) }
    }

    @Published var title: String {
        didSet { _setTitle(title) }
    }

    @Published var type: MissionConditionType {
        didSet { _setType(type) }
    }

    @Published var isCompleted: Bool

    init<T: MissionCondition>(_ provider: T) {
        let mutableProvider = provider
        _getValue = { mutableProvider.value }
        _setValue = { newValue in
            if let typedValue = newValue as? T.ValueType {
                mutableProvider.value = typedValue
            }
        }
        value = _getValue()

        _getGoal = { mutableProvider.goal }
        _setGoal = { newValue in
            mutableProvider.goal = newValue
        }
        goal = _getGoal()

        _getTitle = { mutableProvider.title }
        _setTitle = { newValue in
            mutableProvider.title = newValue
        }
        title = _getTitle()

        _getType = { mutableProvider.type }
        _setType = { newValue in
            mutableProvider.type = newValue
        }
        type = _getType()

        _getIsCompleted = { mutableProvider.isCompleted() }
        isCompleted = _getIsCompleted()
    }
}

class ImageCondition: MissionCondition, ObservableObject {
    typealias ValueType = [UIImage]
    var type: MissionConditionType = .image

    var id = UUID()
    var title: String
    var goal: Double
    @Published var value: [UIImage]

    init(title: String, goal: Double, value: [UIImage]) {
        self.title = title
        self.goal = goal
        self.value = value
    }

    func isCompleted() -> Bool {
        return Double(value.count) >= goal
    }
}

class HealthKitCondition: MissionCondition, ObservableObject {
    typealias ValueType = Double
    var type: MissionConditionType = .healthKit

    var id = UUID()
    let healthType: HealthKitConditionType
    var title: String
    @Published var value: Double
    var goal: Double

    init(healthType: HealthKitConditionType, title: String, value: Double, goal: Double) {
        self.healthType = healthType
        self.title = title
        self.value = value
        self.goal = goal
    }

    func isCompleted() -> Bool {
        switch healthType {
        case .steps:
            return value >= goal
        case .calories:
            return value >= goal
        case .water:
            return value >= goal
        }
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

//
//  MissionDetailViewModel.swift
//  Artia
//
//  Created by Vick on 3/29/25.
//

import Foundation
import OSLog

class MissionDetailViewModel: ObservableObject {
    var healthService: HealthService = .init()

    func getHealthData(by type: HealthKitConditionType, startDate: Date, endDate: Date) async -> Double {
        do {
            switch type {
            case .steps:
                let steps = try await healthService.fetchSteps(
                    from: startDate,
                    to: endDate
                )
                return Double(steps)
            case .calories:
                let calories = try await healthService.fetchCalories(
                    from: startDate,
                    to: endDate
                )
                return Double(calories)
            case .water:
                let water = try await healthService.fetchWaterIntake(
                    from: startDate,
                    to: endDate
                )
                return Double(water)
            }
        } catch {
            Logger.general.error("\(i18n.failedToGetHealthData.localized(with: error.localizedDescription))")
            return 0
        }
    }
}

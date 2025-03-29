import SwiftUI

struct MissionDetailView: View {
    @EnvironmentObject private var store: MissionStore
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mission: Mission
    @StateObject var viewModel: MissionDetailViewModel = .init()

    // FIXME: This is a temporary workaround to update the UI when the mission is completed.
    @State private var tempWalkaroundIsCompleted: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    MissionInfoView(mission: mission, story: store.getStory(by: mission))

                    Divider()

                    if !mission.rewards.isEmpty {
                        RewardView(rewards: mission.rewards)
                        Divider()
                    }

                    ConditionView(mission: mission, onConditionUpdate: {
                        tempWalkaroundIsCompleted = mission.canCompleted
                    }, getHealthDataValue: { mission, healthType in
                        guard let startDate = mission.takenDate else {
                            fatalError("Mission date is not set.")
                        }
                        return await viewModel.getHealthData(
                            by: healthType,
                            startDate: startDate,
                            endDate: Calendar.current.endOfDay()
                        )
                    })

                    Spacer()

                    Text("\(tempWalkaroundIsCompleted)")
                        .hidden()
                }
                .padding()
            }

            RichButton(title: i18n.finish.localized, color: .black, icon: "sparkle", disabled: mission.canNotCompleted) {
                mission.finish()
                dismiss()
            }
            .padding()
        }
        .background(Color(.primaryBackground))
        .onAppear {
            tempWalkaroundIsCompleted = mission.canCompleted
        }
    }
}

private struct MissionInfoView: View {
    let mission: Mission
    let story: Story?

    var body: some View {
        Text(mission.type.text)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black)
            .clipShape(Capsule())

        Text(mission.title)
            .font(.title)

        Text(mission.description.isEmpty ? "-" : mission.description)
            .foregroundColor(.secondary)

        if let story {
            HStack {
                Image(systemName: "person.fill.turn.right")
                Text(story.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

private struct RewardView: View {
    let rewards: [MissionReward]

    var body: some View {
        VStack {
            Text(i18n.reward.localized)
                .font(.subheadline)
                .fontWeight(.medium)

            ForEach(rewards) { reward in
                HStack {
                    Image(systemName: "seal.fill")
                    Text(reward.title)
                }
            }
        }
    }
}

private struct ConditionView: View {
    @ObservedObject var mission: Mission
    var onConditionUpdate: () -> Void
    var getHealthDataValue: (_ mission: Mission, _ healthType: HealthKitConditionType) async throws -> Double

    var body: some View {
        ForEach(mission.conditions.indices) { index in
            switch mission.conditions[index] {
            case let imageCondition as ImageCondition:
                ImagesConditionView(condition: imageCondition, onUpdate: onConditionUpdate)
            case let healthCondition as HealthKitCondition:
                HealthKitConditionView(condition: healthCondition, mission: mission, onUpdate: onConditionUpdate) {
                    try await getHealthDataValue(mission, healthCondition.healthType)
                }
            default:
                Spacer()
            }
        }
    }
}

private struct ImagesConditionView: View {
    @ObservedObject var condition: ImageCondition
    var onUpdate: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(condition.title)
                    .font(.headline)
                Text("\(condition.value.count)/\(Int(condition.goal))")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                if condition.isCompleted() {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.repeatTaskGreen)
                }
            }
            ImageUploader(
                images: Binding(get: {
                    condition.value
                }, set: { newValue in
                    condition.value = newValue
                    onUpdate()
                }),
                maxCount: Int(condition.goal)
            )
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct HealthKitConditionView: View {
    @ObservedObject var condition: HealthKitCondition
    @ObservedObject var mission: Mission
    var onUpdate: () -> Void
    var getHealthDataValue: () async throws -> Double

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(condition.title)
                    .font(.headline)
                if condition.isCompleted() {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.repeatTaskGreen)
                }
            }
            Spacer(minLength: 10)
            HStack(alignment: .bottom) {
                ProgressView(healthTypeString(condition.healthType), value: condition.value / condition.goal, total: 1)
                    .tint(.repeatTaskGreen)
                Text("\(Int(condition.value))/\(Int(condition.goal))")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .onChange(of: condition.value) { _, _ in
            onUpdate()
        }
        .onAppear {
            Task {
                Task {
                    condition.value = try await getHealthDataValue()
                }
            }
        }
    }

    private func healthTypeString(_ type: HealthKitConditionType) -> String {
        switch type {
        case .calories:
            return i18n.calories.localized
        case .steps:
            return i18n.steps.localized
        case .water:
            return i18n.water.localized
        }
    }
}

#Preview {
    MissionDetailView(mission: MockData.mission)
        .environmentObject(MissionStore())
}

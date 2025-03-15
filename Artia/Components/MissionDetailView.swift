import SwiftUI

struct MissionDetailView: View {
    @EnvironmentObject private var store: MissionStore
    @Binding var mission: Mission

    // FIXME: This is a temporary workaround to update the UI when the mission is completed.
    @State private var tempWalkaroundIsCompleted: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text(mission.type.text)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(mission.type.color)
                        .clipShape(Capsule())

                    Text(mission.title)
                        .font(.title)

                    Text(mission.description.isEmpty ? "-" : mission.description)
                        .foregroundColor(.secondary)

                    if let storyId = mission.storyId, let story = store.getStory(by: storyId) {
                        HStack {
                            Image(systemName: "person.fill.turn.right")
                            Text(story.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }

                    Divider()

                    if !mission.rewards.isEmpty {
                        RewardView(rewards: mission.rewards)
                        Divider()
                    }

                    ConditionView(mission: $mission, onConditionUpdate: {
                        mission.updateCompleted()
                        tempWalkaroundIsCompleted = mission.isCompleted
                    })

                    Spacer()
                }
                .padding()
            }

            Button {} label: {
                Text("Finish")
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 8)
                    .background(mission.isCompleted ? Color.black : Color.gray)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!mission.isCompleted)
            .padding()
        }
        .background(Color(.primaryBackground))
        .onAppear {
            mission.updateCompleted()
            tempWalkaroundIsCompleted = mission.isCompleted
        }
    }
}

private struct RewardView: View {
    let rewards: [MissionReward]

    var body: some View {
        VStack {
            Text("Reward")
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
    @Binding var mission: Mission
    var onConditionUpdate: () -> Void

    var body: some View {
        ForEach(mission.conditions.indices) { index in
            switch mission.conditions[index] {
            case let imageCondition as ImageCondition:
                ImagesConditionView(condition: imageCondition, onUpdate: onConditionUpdate)
            case let healthCondition as HealthKitCondition:
                HealthKitConditionView(condition: healthCondition, onUpdate: onConditionUpdate)
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
    var onUpdate: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Health")
                    .font(.headline)
                if condition.isCompleted() {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.repeatTaskGreen)
                }
            }
            Spacer(minLength: 10)
            HStack(alignment: .bottom) {
                ProgressView("Steps", value: condition.value)
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
    }
}

#Preview {
    MissionDetailView(mission: .constant(MockData.task))
}

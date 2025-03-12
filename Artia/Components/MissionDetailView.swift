import SwiftUI

struct MissionDetailView: View {
    @State var mission: Mission

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text(typeText)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(typeColor)
                        .clipShape(Capsule())

                    Text(mission.title)
                        .font(.title)

                    Text(mission.description.isEmpty ? "-" : mission.description)
                        .foregroundColor(.secondary)

                    if let line = mission.story {
                        HStack {
                            Image(systemName: "person.fill.turn.right")
                            Text(line.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }

                    Divider()

                    if !mission.rewards.isEmpty {
                        RewardView(rewards: mission.rewards)
                        Divider()
                    }

                    ConditionView(mission: $mission)

                    Spacer()
                }
                .padding()
            }

            Button {
                print("Finish")
            } label: {
                if mission.isCompletedConditions {
                    Text("Finish")
                        .padding([.leading, .trailing], 16)
                        .padding([.top, .bottom], 8)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Text("Finish")
                        .padding([.leading, .trailing], 16)
                        .padding([.top, .bottom], 8)
                        .background(Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .disabled(mission.isUncompleted)
            .padding()
        }
        .background(Color(.primaryBackground))
    }

    private var typeText: String {
        switch mission.type {
        case .main:
            return "Main"
        case .side:
            return "Side"
        case .repeat:
            return "Repeat"
        }
    }

    private var typeColor: Color {
        switch mission.type {
        case .main:
            return .mainTaskYellow
        case .side:
            return .sideTaskBlue
        case .repeat:
            return .repeatTaskGreen
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
                    Image(systemName: "staroflife.fill")
                    Text(reward.title)
                }
            }
        }
    }
}

private struct ConditionView: View {
    @Binding var mission: Mission

    // FIXME: walkaround → tempWalkAroundImages
    @State private var tempWalkAroundImages: [UIImage] = []
    
    var body: some View {
        ForEach($mission.conditions, id: \.id) { $condition in
            if condition.type == .image {
                VStack(alignment: .leading) {
                    HStack {
                        Text(condition.title)
                            .font(.headline)
                        Text("\((condition.getValue() as! [UIImage]).count)/\(Int(condition.goal))")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        if condition.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.repeatTaskGreen)
                        }
                        
                        // FIXME: walkaround → tempWalkAroundImages
                        Text("\(tempWalkAroundImages.count)")
                            .hidden()
                    }
                    ImageUploader(
                        images: Binding(get: {
                            condition.getValue() as! [UIImage]
                        }, set: { newValue in
                            condition.setValue(newValue)
                            // FIXME: walkaround → tempWalkAroundImages
                            tempWalkAroundImages = newValue
                        }),
                        maxCount: Int(condition.goal)
                    )
                }
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if condition.type == .healthKit {
                VStack(alignment: .leading) {
                    HStack {
                        Text("HealthKit")
                            .font(.headline)
                        if condition.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.repeatTaskGreen)
                        }
                    }
                    Spacer(minLength: 10)
                    HStack(alignment: .bottom) {
                        ProgressView("Steps", value: condition.getValue() as? Double)
                            .tint(.repeatTaskGreen)
                        Text("\(Int(condition.getValue() as! Double))/\((Int(condition.goal)))")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .padding()
            } else {
                Text("-")
            }
        }
    }
}

#Preview {
    MissionDetailView(mission: MockData.task)
}

//
//  CreateMissionView.swift
//  Artia
//
//  Created by Vick on 3/14/25.
//

import PhotosUI
import SwiftUI

struct CreateMissionView: View {
    @EnvironmentObject var store: MissionStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateMissionViewModel

    init(store: MissionStore) {
        _viewModel = StateObject(wrappedValue: CreateMissionViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text(i18n.info.localized)) {
                        TextField(i18n.title.localized, text: $viewModel.title)
                        TextField(i18n.description.localized, text: $viewModel.description, axis: .vertical)
                            .lineLimit(3 ... 5)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.type.localized) {
                        Picker(i18n.missionType.localized, selection: $viewModel.selectedMissionType) {
                            Text(MissionType.main.text).tag(MissionType.main)
                            Text(MissionType.side.text).tag(MissionType.side)
                            Text(MissionType.repeat.text).tag(MissionType.repeat)
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.story.localized) {
                        SelectStoryView(selectedStory: $viewModel.selectedStory, showingStoryPicker: $viewModel.showingStoryPicker)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.conditions.localized) {
                        ConditionListView(conditions: $viewModel.conditions)

                        Button(action: {
                            viewModel.showingAddCondition = true
                        }) {
                            Label(i18n.addCondition.localized, systemImage: "plus.circle")
                                .foregroundStyle(.black)
                        }
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.reward.localized) {
                        RewardListView(rewards: $viewModel.rewards)

                        Button(action: {
                            viewModel.showingAddReward = true
                        }) {
                            Label(i18n.addReward.localized, systemImage: "plus.circle")
                                .foregroundStyle(.black)
                        }
                    }
                    .listRowBackground(Color(.section))
                }
                .scrollContentBackground(.hidden)
                .background(Color(.primaryBackground))
                .navigationTitle(i18n.createMission.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(i18n.cancel.localized) {
                            dismiss()
                        }
                        .tint(.black)
                    }
                }

                Spacer()

                RichButton(title: i18n.create.localized, color: Color.buttonBackground, icon: "sparkle", disabled: viewModel.title.isEmpty) {
                    Task {
                        await viewModel.createMission()
                        dismiss()
                    }
                }
                .padding()
            }
            .sheet(isPresented: $viewModel.showingStoryPicker) {
                StoryPickerView(selectedStory: $viewModel.selectedStory, stories: store.stories)
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showingAddCondition) {
                AddConditionView(conditions: $viewModel.conditions, showingAddCondition: $viewModel.showingAddCondition)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showingAddReward) {
                AddRewardView(rewards: $viewModel.rewards, showingAddReward: $viewModel.showingAddReward)
                    .interactiveDismissDisabled()
                    .presentationDetents([.medium])
            }
        }
    }
}

struct ConditionListView: View {
    @Binding var conditions: [any MissionCondition]

    var body: some View {
        ForEach(Array(conditions.enumerated()), id: \.offset) { index, condition in
            if let imageCondition = condition as? ImageCondition {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(i18n.imageCondition.localized)
                                .font(.headline)
                            Text("\(Int(imageCondition.goal))x Images")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }

                        Text("\(imageCondition.title)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: {
                        conditions.remove(at: index)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            } else if let healthCondition = condition as? HealthKitCondition {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(i18n.healthCondition.localized)
                                .font(.headline)
                            Text("\(Int(healthCondition.goal)) \(healthTypeUnit(healthCondition.healthType))")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }

                        Text("\(healthCondition.title)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: {
                        conditions.remove(at: index)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }

    private func healthTypeUnit(_ type: HealthKitConditionType) -> String {
        switch type {
        case .steps:
            return i18n.steps.localized
        case .calories:
            return i18n.calories.localized
        case .water:
            return i18n.ml.localized
        }
    }
}

struct RewardListView: View {
    @Binding var rewards: [MissionReward]

    var body: some View {
        ForEach(Array(rewards.enumerated()), id: \.offset) { index, reward in
            HStack {
                VStack(alignment: .leading) {
                    Text(reward.title)
                        .font(.headline)
                    if !reward.description.isEmpty {
                        Text(reward.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(action: {
                    rewards.remove(at: index)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct AddConditionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var conditions: [any MissionCondition]
    @Binding var showingAddCondition: Bool
    @State private var conditionType: MissionConditionType = .image
    @State private var conditionTitle = ""
    @State private var conditionGoal: Double = 1
    @State private var selectedHealthType: HealthKitConditionType = .steps

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(i18n.type.localized) {
                        Picker(i18n.type.localized, selection: $conditionType) {
                            Text(i18n.image.localized).tag(MissionConditionType.image)
                            Text(i18n.health.localized).tag(MissionConditionType.healthKit)
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.info.localized) {
                        TextField(i18n.title.localized, text: $conditionTitle)

                        if conditionType == .healthKit {
                            Picker(i18n.healthCategory.localized, selection: $selectedHealthType) {
                                Text(i18n.steps.localized).tag(HealthKitConditionType.steps)
                                Text(i18n.calories.localized).tag(HealthKitConditionType.calories)
                                Text(i18n.ml.localized).tag(HealthKitConditionType.water)
                            }
                            .pickerStyle(.menu)
                            .tint(.gray)
                        }

                        HStack {
                            Text(i18n.goal.localized)
                            Spacer()
                            Stepper("\(Int(conditionGoal))", value: $conditionGoal, in: 1 ... 100)
                        }
                    }
                    .listRowBackground(Color(.section))
                }

                Spacer()

                RichButton(title: i18n.add.localized, color: Color.buttonBackground, icon: "sparkle", disabled: conditionTitle.isEmpty) {
                    addCondition()
                    showingAddCondition = false
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .background(Color(.primaryBackground))
            .navigationTitle(i18n.addCondition.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(i18n.cancel.localized) {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }

    private func addCondition() {
        if conditionType == .image {
            let newCondition = ImageCondition(
                title: conditionTitle,
                goal: conditionGoal,
                value: []
            )
            conditions.append(newCondition)
        } else {
            let newCondition = HealthKitCondition(
                healthType: selectedHealthType,
                title: conditionTitle,
                value: 0,
                goal: conditionGoal
            )
            conditions.append(newCondition)
        }

        conditionTitle = ""
        conditionGoal = 1
    }
}

struct AddRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var rewards: [MissionReward]
    @Binding var showingAddReward: Bool
    @State private var rewardTitle = ""
    @State private var rewardDescription = ""

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(i18n.info.localized) {
                        TextField(i18n.title.localized, text: $rewardTitle)
                        TextField(i18n.description.localized, text: $rewardDescription, axis: .vertical)
                            .lineLimit(2 ... 4)
                    }
                    .listRowBackground(Color(.section))
                }

                Spacer()

                RichButton(title: i18n.add.localized, color: Color.buttonBackground, icon: "sparkle", disabled: rewardTitle.isEmpty) {
                    addReward()
                    showingAddReward = false
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .background(Color(.primaryBackground))
            .navigationTitle(i18n.addReward.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(i18n.cancel.localized) {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }

    private func addReward() {
        let newReward = MissionReward(
            title: rewardTitle,
            description: rewardDescription
        )
        rewards.append(newReward)

        rewardTitle = ""
        rewardDescription = ""
    }
}

#Preview {
    CreateMissionView(store: MissionStore())
        .environmentObject(MissionStore())
}

struct SelectStoryView: View {
    @Binding var selectedStory: Story?
    @Binding var showingStoryPicker: Bool

    var body: some View {
        if let story = selectedStory {
            HStack {
                VStack(alignment: .leading) {
                    Text(story.title)
                        .font(.headline)
                    Text(story.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    selectedStory = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        } else {
            Button(action: {
                showingStoryPicker = true
            }) {
                Label(i18n.selectStory.localized, systemImage: "book")
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    SelectStoryView(
        selectedStory: .constant(
            nil
        ),
        showingStoryPicker: .constant(false)
    )
}

#Preview {
    AddConditionView(conditions: .constant([]), showingAddCondition: .constant(false))
}

#Preview {
    AddRewardView(rewards: .constant([]), showingAddReward: .constant(false))
}

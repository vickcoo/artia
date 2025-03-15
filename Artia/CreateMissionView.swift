//
//  CreateMissionView.swift
//  Artia
//
//  Created by Vick on 3/14/25.
//

import PhotosUI
import SwiftUI

struct CreateMissionView: View {
    @EnvironmentObject var missionStore: MissionStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var selectedMissionType: MissionType = .main
    @State private var selectedStory: Story?
    @State private var showingStoryPicker = false

    // Condition states
    @State private var conditions: [any MissionCondition] = []
    @State private var showingAddCondition = false

    // Reward states
    @State private var rewards: [MissionReward] = []
    @State private var showingAddReward = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Info")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3 ... 5)
                }
                .listRowBackground(Color(.section))

                Section("Type") {
                    Picker("Mission Type", selection: $selectedMissionType) {
                        Text(MissionType.main.text).tag(MissionType.main)
                        Text(MissionType.side.text).tag(MissionType.side)
                        Text(MissionType.repeat.text).tag(MissionType.repeat)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color(.section))

                Section("Story (Optional)") {
                    SelectStoryView(selectedStory: $selectedStory, showingStoryPicker: $showingStoryPicker)
                }
                .listRowBackground(Color(.section))

                Section("Conditions") {
                    ConditionListView(conditions: $conditions)

                    Button(action: {
                        showingAddCondition = true
                    }) {
                        Label("Add Condition", systemImage: "plus.circle")
                            .foregroundStyle(.black)
                    }
                }
                .listRowBackground(Color(.section))

                Section("Rewards (Optional)") {
                    RewardListView(rewards: $rewards)

                    Button(action: {
                        showingAddReward = true
                    }) {
                        Label("Add Reward", systemImage: "plus.circle")
                            .foregroundStyle(.black)
                    }
                }
                .listRowBackground(Color(.section))

                Section {
                    Button {
                        createMission()
                    } label: {
                        Text("Create")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .foregroundStyle(title.isEmpty ? .buttonDisableForeground : .buttonForeground)
                            .background(title.isEmpty ? Color(.buttonDisableBackground) : Color(.buttonBackground))
                            .cornerRadius(16)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.primaryBackground))
            .navigationTitle("Create Mission")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
            .sheet(isPresented: $showingStoryPicker) {
                StoryPickerView(selectedStory: $selectedStory, stories: missionStore.stories)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingAddCondition) {
                AddConditionView(conditions: $conditions, showingAddCondition: $showingAddCondition)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingAddReward) {
                AddRewardView(rewards: $rewards, showingAddReward: $showingAddReward)
                    .interactiveDismissDisabled()
                    .presentationDetents([.medium])
            }
        }
    }

    private func createMission() {
        let newMission = Mission(
            title: title,
            description: description,
            status: .todo,
            type: selectedMissionType,
            storyId: selectedStory?.id,
            conditions: conditions,
            rewards: rewards
        )

        Task {
            missionStore.createMission(newMission)
            dismiss()
        }
    }
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
                        .foregroundColor(.gray)
                }
            }
        } else {
            Button(action: {
                showingStoryPicker = true
            }) {
                Label("Select Story", systemImage: "book")
                    .foregroundStyle(.black)
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
                            Text("Image Condition")
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
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            } else if let healthCondition = condition as? HealthKitCondition {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Health Condition")
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
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }

    private func healthTypeUnit(_ type: HealthKitConditionType) -> String {
        switch type {
        case .steps:
            return "Steps"
        case .calories:
            return "Calories"
        case .water:
            return "ml"
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
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct StoryPickerView: View {
    @Binding var selectedStory: Story?
    let stories: [Story]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(MockData.stories) { story in
                    Button(action: {
                        selectedStory = story
                        dismiss()
                    }) {
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            Text(story.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .navigationTitle("Select Story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.black)
                }
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
            Form {
                Section("Type") {
                    Picker("Type", selection: $conditionType) {
                        Text("Image").tag(MissionConditionType.image)
                        Text("Health").tag(MissionConditionType.healthKit)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color(.section))

                Section("Info") {
                    TextField("Title", text: $conditionTitle)

                    if conditionType == .healthKit {
                        Picker("Health Category", selection: $selectedHealthType) {
                            Text("Steps").tag(HealthKitConditionType.steps)
                            Text("Calories").tag(HealthKitConditionType.calories)
                            Text("ML").tag(HealthKitConditionType.water)
                        }
                        .pickerStyle(.menu)
                        .tint(.brown)
                    }

                    HStack {
                        Text("Goal")
                        Spacer()
                        Stepper("\(Int(conditionGoal))", value: $conditionGoal, in: 1 ... 100)
                    }
                }
                .listRowBackground(Color(.section))

                Section {
                    Button {
                        addCondition()
                        showingAddCondition = false
                    } label: {
                        Text("Add")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .foregroundStyle(conditionTitle.isEmpty ? .buttonDisableForeground : .buttonForeground)
                            .background(conditionTitle.isEmpty ? Color(.buttonDisableBackground) : Color(.buttonBackground))
                            .cornerRadius(16)
                    }
                    .disabled(conditionTitle.isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.primaryBackground))
            .navigationTitle("Add Condition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
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
            Form {
                Section("Info") {
                    TextField("Title", text: $rewardTitle)
                    TextField("Description", text: $rewardDescription, axis: .vertical)
                        .lineLimit(2 ... 4)
                }
                .listRowBackground(Color(.section))

                Section {
                    Button {
                        addReward()
                        showingAddReward = false
                    } label: {
                        Text("Add")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .foregroundStyle(rewardTitle.isEmpty ? .buttonDisableForeground : .buttonForeground)
                            .background(rewardTitle.isEmpty ? Color(.buttonDisableBackground) : Color(.buttonBackground))
                            .cornerRadius(16)
                    }
                    .disabled(rewardTitle.isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.primaryBackground))
            .navigationTitle("Add Reward")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
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
    CreateMissionView()
        .environmentObject(MissionStore())
}

#Preview {
    StoryPickerView(selectedStory: .constant(nil), stories: [])
}

#Preview {
    AddConditionView(conditions: .constant([]), showingAddCondition: .constant(false))
}

#Preview {
    AddRewardView(rewards: .constant([]), showingAddReward: .constant(false))
}

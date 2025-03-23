import PhotosUI
import SwiftUI

struct EditMissionView: View {
    @EnvironmentObject var missionStore: MissionStore
    @Environment(\.dismiss) private var dismiss

    let mission: Mission

    @State private var title: String
    @State private var description: String
    @State private var selectedMissionType: MissionType
    @State private var selectedStory: Story?
    @State private var showingStoryPicker = false

    // Condition states
    @State private var conditions: [any MissionCondition]
    @State private var showingAddCondition = false

    // Reward states
    @State private var rewards: [MissionReward]
    @State private var showingAddReward = false

    var completion: () -> Void = { }
    
    init(mission: Mission, story: Story, completion: @escaping () -> Void = { }) {
        self.mission = mission

        _title = State(initialValue: mission.title)
        _description = State(initialValue: mission.description)
        _selectedMissionType = State(initialValue: mission.type)
        _conditions = State(initialValue: mission.conditions)
        _rewards = State(initialValue: mission.rewards)
        _selectedStory = State(initialValue: story)
        self.completion = completion
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text(i18n.info.localized)) {
                        TextField(i18n.title.localized, text: $title)
                        TextField(i18n.description.localized, text: $description, axis: .vertical)
                            .lineLimit(3 ... 5)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.type.localized) {
                        Picker(i18n.type.localized, selection: $selectedMissionType) {
                            Text(MissionType.main.text).tag(MissionType.main)
                            Text(MissionType.side.text).tag(MissionType.side)
                            Text(MissionType.repeat.text).tag(MissionType.repeat)
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.story.localized) {
                        SelectStoryView(selectedStory: $selectedStory, showingStoryPicker: $showingStoryPicker)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.conditions.localized) {
                        ConditionListView(conditions: $conditions)

                        Button(action: {
                            showingAddCondition = true
                        }) {
                            Label(i18n.addCondition.localized, systemImage: "plus.circle")
                                .foregroundStyle(.black)
                        }
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.reward.localized) {
                        RewardListView(rewards: $rewards)

                        Button(action: {
                            showingAddReward = true
                        }) {
                            Label(i18n.addReward.localized, systemImage: "plus.circle")
                                .foregroundStyle(.black)
                        }
                    }
                    .listRowBackground(Color(.section))
                }
                .scrollContentBackground(.hidden)
                .background(Color(.primaryBackground))
                .navigationTitle(i18n.editMission.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text(i18n.cancel.localized)
                                .tint(.black)
                        }
                    }
                }

                Spacer()

                RichButton(title: i18n.save.localized, color: Color.buttonBackground, icon: "sparkle", disabled: title.isEmpty) {
                    saveMission()
                    completion()
                }
                .padding()
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

    private func saveMission() {
        guard let selectedStory else { return }

        let updatedMission = Mission(
            id: mission.id,
            title: title,
            description: description,
            status: mission.status,
            type: selectedMissionType,
            conditions: conditions,
            rewards: rewards
        )

        missionStore.updateMission(mission: updatedMission, in: selectedStory)
    }
}

#Preview {
    EditMissionView(mission: MockData.mission, story: MockData.story)
        .environmentObject(MissionStore())
}

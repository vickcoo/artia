import PhotosUI
import SwiftUI

struct EditMissionView: View {
    @EnvironmentObject var store: MissionStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditMissionViewModel

    var completion: () -> Void = {}

    init(store: MissionStore, mission: Mission, story: Story, completion: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: EditMissionViewModel(store: store, mission: mission, story: story)
        )
        self.completion = completion
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
                        Picker(i18n.type.localized, selection: $viewModel.selectedMissionType) {
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

                RichButton(title: i18n.save.localized, color: Color.buttonBackground, icon: "sparkle", disabled: viewModel.title.isEmpty) {
                    viewModel.saveMission()
                    completion()
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

#Preview {
    EditMissionView(store: MissionStore(), mission: MockData.mission, story: MockData.story)
        .environmentObject(MissionStore())
}

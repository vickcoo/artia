//
//  MissionPickerView.swift
//  Artia
//
//  Created by Vick on 3/18/25.
//

import SwiftUI

struct MissionPickerView: View {
    @EnvironmentObject var store: MissionStore
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMission: Mission?
    @State private var filteredStory: Story?
    @State private var filteredMissionType: MissionType?
    var completion: () -> Void = { }
    
    private var storyDropdownOptions: [DropdownChipOption<Story>] {
        store.stories.map { story in
            DropdownChipOption(id: story.id, title: story.title, value: story)
        }
    }

    private var missionTypeOptions: [DropdownChipOption<MissionType>] {
        [
            DropdownChipOption(id: MissionType.main.rawValue, title: MissionType.main.text, value: .main),
            DropdownChipOption(id: MissionType.side.rawValue, title: MissionType.side.text, value: .side),
            DropdownChipOption(id: MissionType.repeat.rawValue, title: MissionType.repeat.text, value: .repeat),
        ]
    }

    var filteredMissions: [Mission] {
        var missions = store.getAllMission()

        if let story = filteredStory {
            missions = story.missions
        }

        if let missionType = filteredMissionType {
            missions = missions.filter { $0.type == missionType }
        }

        return missions
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 12) {
                    Dropdown(
                        selectedOption: $filteredStory,
                        options: storyDropdownOptions,
                        title: i18n.selectStory.localized,
                        allOptionTitle: i18n.all.localized
                    )

                    Dropdown(
                        selectedOption: $filteredMissionType,
                        options: missionTypeOptions,
                        title: i18n.missionType.localized,
                        allOptionTitle: i18n.all.localized
                    )
                }
                .padding(.horizontal)

                List {
                    ForEach(filteredMissions) { mission in
                        NavigationLink {
                            EditMissionView(store: store, mission: mission, story: store.getStory(by: mission)!) {
                                completion()
                            }
                                .navigationBarBackButtonHidden()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(mission.title)
                                    .font(.headline)
                                Text(mission.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(Color.primaryBackground)
                .navigationTitle(i18n.selectMission.localized)
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
    }
}

#Preview {
    MissionPickerView(selectedMission: .constant(nil))
        .environmentObject(MissionStore())
}

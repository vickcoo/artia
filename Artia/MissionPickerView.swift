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
    var completion: (Mission) -> Void = { _ in }
    
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
                        title: "Select Story",
                        allOptionTitle: "All"
                    )

                    Dropdown(
                        selectedOption: $filteredMissionType,
                        options: missionTypeOptions,
                        title: "Mission Type",
                        allOptionTitle: "All"
                    )
                }
                .padding(.horizontal)

                List {
                    ForEach(filteredMissions) { mission in
                        Button(action: {
                            selectedMission = mission
                            completion(mission)
                            dismiss()
                        }) {
                            VStack(alignment: .leading) {
                                Text(mission.title)
                                    .font(.headline)
                                Text(mission.description)
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
                .navigationTitle("Select Mission")
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
}

#Preview {
    MissionPickerView(selectedMission: .constant(nil))
        .environmentObject(MissionStore())
}

//
//  CreateStoryView.swift
//  Artia
//
//  Created by Vick on 3/13/25.
//

import SwiftUI

struct CreateStoryView: View {
    @EnvironmentObject var store: MissionStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var showingAddMission = false
    @State private var missions: [Mission] = []

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text(i18n.info.localized)) {
                        TextField(i18n.title.localized, text: $title)
                        TextField(i18n.description.localized, text: $description, axis: .vertical)
                            .lineLimit(4 ... 6)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.missions.localized) {
                        MissionList(missions: $missions, deleteMission: deleteMission)

                        Button(action: {
                            showingAddMission = true
                        }) {
                            Label(i18n.addMission.localized, systemImage: "plus.circle")
                                .foregroundStyle(.black)
                        }
                    }
                    .listRowBackground(Color(.section))
                }
                .scrollContentBackground(.hidden)
                .background(Color(.primaryBackground))
                .navigationTitle(i18n.createStory.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(i18n.cancel.localized) {
                            dismiss()
                        }
                        .tint(.black)
                    }
                }
                .sheet(isPresented: $showingAddMission) {
                    StoryCreateMissionView(showingAddMission: $showingAddMission, missions: $missions)
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled()
                }

                Spacer()

                RichButton(title: i18n.add.localized, color: Color.buttonBackground, icon: "sparkle", disabled: title.isEmpty) {
                    saveStory()
                }
                .padding()
            }
        }
    }

    private func deleteMission(at _: IndexSet) {}

    private func saveStory() {
        let story = Story(
            title: title,
            content: description,
            missions: missions
        )

        store.addStory(story)
        dismiss()
    }
}

private struct MissionList: View {
    @Binding var missions: [Mission]
    var deleteMission: (IndexSet) -> Void

    var body: some View {
        ForEach(missions) { mission in
            VStack(alignment: .leading) {
                HStack {
                    Text(mission.type.text)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], 8)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(.caption)
                    Text(mission.title)
                        .font(.headline)
                }

                if mission.description.isEmpty == false {
                    Text(mission.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .onDelete(perform: deleteMission)
    }
}

private struct StoryCreateMissionView: View {
    @State private var newMissionTitle = ""
    @State private var newMissionDescription = ""
    @State private var selectedMissionType: MissionType = .main
    @Binding var showingAddMission: Bool
    @Binding var missions: [Mission]

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text(i18n.info.localized)) {
                        TextField(i18n.title.localized, text: $newMissionTitle)

                        TextField(i18n.description.localized, text: $newMissionDescription, axis: .vertical)
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
                }
                .scrollContentBackground(.hidden)
                .background(Color.primaryBackground)
                .navigationTitle(i18n.addMission.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(i18n.cancel.localized) {
                            showingAddMission = false
                        }
                        .tint(.black)
                    }
                }

                Spacer()

                RichButton(title: i18n.add.localized, color: Color.buttonBackground, icon: "sparkle", disabled: newMissionTitle.isEmpty) {
                    addMission()
                    showingAddMission = false
                }
                .padding()
            }
        }
    }

    private func addMission() {
        let newMission = Mission(
            title: newMissionTitle,
            description: newMissionDescription,
            status: .todo,
            type: selectedMissionType,
            conditions: [],
            rewards: []
        )

        missions.append(newMission)
        newMissionTitle = ""
        newMissionDescription = ""
        selectedMissionType = .main
    }
}

#Preview("CreateStoryView") {
    CreateStoryView()
        .environmentObject(MissionStore())
}

#Preview("StoryCreateMissionView") {
    StoryCreateMissionView(showingAddMission: .constant(true), missions: .constant([]))
}

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
            Form {
                Section(header: Text("Info")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(4 ... 6)
                }
                .listRowBackground(Color.brown.opacity(0.1))

                Section("Missions (Optional)") {
                    MissionList(missions: $missions, deleteMission: deleteMission)

                    Button(action: {
                        showingAddMission = true
                    }) {
                        Label("Add Mission", systemImage: "plus.circle")
                            .foregroundStyle(.black)
                    }
                }
                .listRowBackground(Color.brown.opacity(0.1))

                Section {
                    Button("Create") {
                        saveStory()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(title.isEmpty ? .gray : .black)
                    .disabled(title.isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.primaryBackground))
            .navigationTitle("Create a story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
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
        }
    }

    private func deleteMission(at offsets: IndexSet) {
    }

    private func saveStory() {
        let story = Story(
            title: title,
            content: description
        )

        store.addStory(story)
        
        for mission in missions {
            let newMission = Mission(
                title: mission.title,
                description: mission.description,
                status: mission.status,
                type: mission.type,
                storyId: story.id,
                conditions: mission.conditions,
                rewards: mission.rewards
            )
            store.createMission(newMission)
        }

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
                        .background(mission.type.color)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
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
            Form {
                Section(header: Text("Mission Info")) {
                    TextField("Title", text: $newMissionTitle)

                    TextField("Description", text: $newMissionDescription, axis: .vertical)
                        .lineLimit(3 ... 5)
                }
                .listRowBackground(Color.brown.opacity(0.1))

                Section("Type") {
                    Picker("Type", selection: $selectedMissionType) {
                        Text(MissionType.main.text).tag(MissionType.main)
                        Text(MissionType.side.text).tag(MissionType.side)
                        Text(MissionType.repeat.text).tag(MissionType.repeat)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.brown.opacity(0.1))

                Section {
                    Button("Add") {
                        addMission()
                        showingAddMission = false
                    }
                    .frame(maxWidth: .infinity)
                    .tint(.black)
                    .disabled(newMissionTitle.isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .navigationTitle("Add Mission")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        showingAddMission = false
                    }
                    .tint(.black)
                }
            }
        }
    }

    private func addMission() {
        let newMission = Mission(
            title: newMissionTitle,
            description: newMissionDescription,
            status: .todo,
            type: selectedMissionType,
            storyId: nil,
            conditions: [],
            rewards: []
        )

        missions.append(newMission)
        newMissionTitle = ""
        newMissionDescription = ""
        selectedMissionType = .main
    }
}

#Preview {
    CreateStoryView()
        .environmentObject(MissionStore())
}

#Preview {
    StoryCreateMissionView(showingAddMission: .constant(true), missions: .constant([]))
}

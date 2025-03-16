//
//  TasksView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

struct MissionsView: View {
    @EnvironmentObject private var store: MissionStore
    @State var selectedStoryId: UUID?
    @Binding var showingDetail: Bool
    @Binding var selectedMissionId: UUID?

    var missionsFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            return store.missions.filter { $0.storyId == selectedStoryId }
        } else {
            return store.missions
        }
    }

    private var storyChipOptions: [ChipOption] {
        store.stories.map { ChipOption(id: $0.id, title: $0.title) }
    }

    var body: some View {
        VStack {
            ChipView(selectedOptionId: $selectedStoryId, options: storyChipOptions)

            ScrollView {
                LazyVStack(spacing: 16) {
                    let mainMissions = missionsFilterByStory.filter { $0.type == .main && $0.isUncompleted }
                    let sideMissions = missionsFilterByStory.filter { $0.type == .side && $0.isUncompleted }
                    let repeatMissions = missionsFilterByStory.filter { $0.type == .repeat && $0.isUncompleted }

                    if mainMissions.isEmpty == false {
                        MissionList(title: mainMissions.first?.type.text ?? "-", missions: mainMissions) { mission in
                            showingDetail = true
                            selectedMissionId = mission.id
                        }
                    }

                    if sideMissions.isEmpty == false {
                        MissionList(title: sideMissions.first?.type.text ?? "-", missions: sideMissions) { mission in
                            showingDetail = true
                            selectedMissionId = mission.id
                        }
                    }

                    if repeatMissions.isEmpty == false {
                        MissionList(title: repeatMissions.first?.type.text ?? "-", missions: repeatMissions) { mission in
                            showingDetail = true
                            selectedMissionId = mission.id
                        }
                    }

                    if missionsFilterByStory.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "tray")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)

                            if selectedStoryId != nil {
                                Text("No Mission for this Story")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            } else {
                                Text("No Mission")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    }
                }
                .padding()
            }
        }
    }
}

private struct MissionList: View {
    @EnvironmentObject private var store: MissionStore
    let title: String
    let missions: [Mission]
    let tapAction: (Mission) -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            ForEach(missions.indices, id: \.self) { index in
                let mission = missions[index]
                MissionCard(mission: mission)
                    .foregroundStyle(.primary)
                    .onTapGesture {
                        tapAction(mission)
                    }
            }
        }
    }
}

struct MissionCard: View {
    @ObservedObject var mission: Mission

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mission.title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(mission.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardBorder, lineWidth: 1)
                .background(Color.secondaryBackground.cornerRadius(12))
        )
    }
}

#Preview {
    MissionsView(showingDetail: .constant(false), selectedMissionId: .constant(nil))
        .environmentObject(MissionStore())
}

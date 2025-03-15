//
//  TasksView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

struct MissionsView: View {
    @EnvironmentObject private var store: MissionStore
    var selectedStoryId: UUID?

    var filteredMissions: [Mission] {
        if let selectedStoryId = selectedStoryId {
            return store.missions.filter { $0.storyId == selectedStoryId }
        } else {
            return store.missions
        }
    }

    var body: some View {
        VStack {
            // MissionTypeStats(missions: filteredMissions)
            // Divider()

            ScrollView {
                LazyVStack(spacing: 16) {
                    let mainMissions = filteredMissions.filter { $0.type == .main }
                    let sideMissions = filteredMissions.filter { $0.type == .side }
                    let repeatMissions = filteredMissions.filter { $0.type == .repeat }

                    if mainMissions.isEmpty == false {
                        Text(mainMissions.first?.type.text ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        ForEach(mainMissions.indices) { index in
                            let mission = mainMissions[index]
                            if let idx = mainMissions.firstIndex(of: mission) {
                                MissionCard(mission: store.missions[idx])
                                    .foregroundStyle(.primary)
                            } else {
                                Text("No Mission")
                            }
                        }
                    }

                    if sideMissions.isEmpty == false {
                        Text(sideMissions.first?.type.text ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        ForEach(sideMissions) { mission in
                            MissionCard(mission: mission)
                                .foregroundStyle(.primary)
                        }
                    }

                    if repeatMissions.isEmpty == false {
                        Text(repeatMissions.first?.type.text ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        ForEach(repeatMissions) { mission in
                            MissionCard(mission: mission)
                                .foregroundStyle(.primary)
                        }
                    }

                    if filteredMissions.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "tray")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)

                            if selectedStoryId != nil {
                                Text("此故事尚無任務")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            } else {
                                Text("尚無任務")
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

struct MissionCard: View {
    @ObservedObject var mission: Mission
    @State private var showingDetail = false
    @EnvironmentObject private var store: MissionStore

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
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            MissionDetailView(mission: mission)
        }
    }
}

#Preview {
    MissionsView()
        .environmentObject(MissionStore())
}

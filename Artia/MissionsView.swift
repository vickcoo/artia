//
//  TasksView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

struct MissionsView: View {
    @EnvironmentObject private var store: MissionStore

    var body: some View {
        VStack {
            MissionTypeStats(missions: store.missions)

            Divider()

            ScrollView {
                LazyVStack(spacing: 16) {
                    let mainMissions = store.missions.filter { $0.type == .main }
                    let sideMissions = store.missions.filter { $0.type == .side }
                    let repeatMissions = store.missions.filter { $0.type == .repeat }
                    if mainMissions.isEmpty == false {
                        Text(mainMissions.first?.type.text ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        ForEach(mainMissions) { mission in
                            MissionCard(mission: mission)
                                .foregroundStyle(.primary)
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
                }
                .padding()
            }
        }
        .background(Color.primaryBackground)
    }
}

struct MissionCard: View {
    @ObservedObject var mission: Mission
    @State private var showingDetail = false

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
        .background(Color(.tabBarBackground))
        .cornerRadius(10)
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

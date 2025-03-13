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
                    ForEach(store.missions) { mission in
                        MissionCard(mission: mission)
                    }
                }
                .padding()
            }
        }
        .background(Color.primaryBackground)
    }
}

struct MissionCard: View {
    @State var mission: Mission
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
            MissionDetailView(mission: $mission)
        }
    }
}

#Preview {
    MissionsView()
        .environmentObject(MissionStore())
}

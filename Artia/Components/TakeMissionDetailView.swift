//
//  TakeMissionDetailView.swift
//  Artia
//
//  Created by Vick on 3/23/25.
//

import SwiftUI

struct TakeMissionDetailView: View {
    @EnvironmentObject private var store: MissionStore
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mission: Mission

    // FIXME: This is a temporary workaround to update the UI when the mission is completed.
    @State private var tempWalkaroundIsCompleted: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    MissionInfoView(mission: mission, story: store.getStory(by: mission))

                    Divider()

                    if !mission.rewards.isEmpty {
                        RewardView(rewards: mission.rewards)
                        Divider()
                    }

                    Text("\(tempWalkaroundIsCompleted)")
                        .hidden()
                }
                .padding()
            }

            RichButton(title: i18n.takeMission.localized, color: .black, icon: "sparkle") {
                mission.take()
                dismiss()
            }
            .padding()
        }
        .background(Color(.primaryBackground))
        .onAppear {
            tempWalkaroundIsCompleted = mission.canCompleted
        }
    }
}

private struct MissionInfoView: View {
    let mission: Mission
    let story: Story?

    var body: some View {
        Text(mission.type.text)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black)
            .clipShape(Capsule())

        Text(mission.title)
            .font(.title)

        Text(mission.description.isEmpty ? "-" : mission.description)
            .foregroundColor(.secondary)

        if let story {
            HStack {
                Image(systemName: "person.fill.turn.right")
                Text(story.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

private struct RewardView: View {
    let rewards: [MissionReward]

    var body: some View {
        VStack {
            Text(i18n.reward.localized)
                .font(.subheadline)
                .fontWeight(.medium)

            ForEach(rewards) { reward in
                HStack {
                    Image(systemName: "seal.fill")
                    Text(reward.title)
                }
            }
        }
    }
}

#Preview {
    TakeMissionDetailView(mission: MockData.stories.first!.missions.first!)
        .environmentObject(MissionStore())
}

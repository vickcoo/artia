//
//  JourneyView.swift
//  Artia
//
//  Created by Vick on 3/15/25.
//

import Charts
import SwiftUI

struct JourneyView: View {
    @EnvironmentObject private var store: MissionStore
    @State private var selectedStoryFilter: UUID? = nil

    var completionRate: Double {
        let totalMissions = store.getAllMission().count
        if totalMissions == 0 { return 0 }

        let completedMissions = store.getAllMission().filter { $0.isCompleted }.count
        return Double(completedMissions) / Double(totalMissions)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OverviewProgressView(missions: store.getAllMission())

                OverviewSection(missions: store.getAllMission())

                GoalSection(missions: store.getAllMission())

                StoryProgressSection(stories: store.stories)

                AchievementSection(missions: store.getAllMission())
            }
            .padding(.horizontal)
        }
    }
}

struct OverviewProgressView: View {
    let missions: [Mission]

    var storyProgress: Double {
        let mainMissions = missions.filter { $0.type == .main }
        guard !mainMissions.isEmpty else { return 0 }

        var finishedMissionCount = 0
        for mission in mainMissions {
            if mission.canCompleted {
                finishedMissionCount += 1
            }
        }

        return Double(finishedMissionCount) / Double(mainMissions.count)
    }

    var formatStoryProgress: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: storyProgress)) ?? "0%"
    }

    var body: some View {
        CardView {
            HStack {
                Image(systemName: "flag.checkered")
                    .font(.system(size: 40))
                    .padding(.trailing, 8)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: geometry.size.width, height: 8)
                                    .opacity(0.3)
                                    .foregroundColor(.gray)
                                    .cornerRadius(4)

                                Rectangle()
                                    .frame(width: geometry.size.width * CGFloat(storyProgress), height: 8)
                                    .foregroundColor(.purple)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)

                        Text("\(formatStoryProgress)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.purple)
                    }
                }

                Spacer()
            }
        }
    }
}

// 概覽區域
struct OverviewSection: View {
    @EnvironmentObject var store: MissionStore
    let missions: [Mission]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                StatCard(
                    icon: "flame.fill",
                    iconColor: .orange,
                    value: "0",
                    label: "Day Streak"
                )

                StatCard(
                    icon: "timer",
                    iconColor: .red,
                    value: "0",
                    label: "Finished Story"
                )
            }

            HStack(spacing: 12) {
                StatCard(
                    icon: "repeat",
                    iconColor: .green,
                    value: "\(missions.filter { $0.canCompleted }.count)",
                    label: "Finished Mission"
                )

                StatCard(
                    icon: "checkmark",
                    iconColor: .blue,
                    value: "0",
                    label: "Rewards"
                )
            }
        }
    }
}

// 統計卡片
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        CardView {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(iconColor)
                        )

                    Spacer()

                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                }

                HStack {
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct StoryProgressSection: View {
    let stories: [Story]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Stories")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }

            if !stories.isEmpty {
                ForEach(stories.prefix(3)) { story in
                    StoryProgressCard(story: story)
                }
            } else {
                EmptyStateView(message: "No any mission")
            }
        }
    }
}

// 目標區域
struct GoalSection: View {
    let missions: [Mission]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Goal")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }

            if missions.isEmpty {
                EmptyGoalView()
            } else {
                if let mainMission = missions.first(where: { $0.type == .main && !$0.canCompleted }) {
                    GoalCard(mission: mainMission)
                } else {
                    EmptyGoalView()
                }
            }
        }
    }
}

struct EmptyGoalView: View {
    var body: some View {
        HStack {
            Image(systemName: "target")
                .foregroundColor(.red)
                .font(.title)

            Text("No goal yet")
                .foregroundColor(.gray)
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
                .background(Color(.systemBackground).cornerRadius(16))
        )
    }
}

struct GoalCard: View {
    @ObservedObject var mission: Mission

    var progressPercentage: Double {
        if mission.conditions.isEmpty { return 0 }

        let completedConditions = mission.conditions.filter { $0.isCompleted() }.count
        return Double(completedConditions) / Double(mission.conditions.count)
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.red)
                        .font(.title2)

                    Text(mission.title)
                        .font(.headline)

                    Spacer()
                }

                Text(mission.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 8)
                            .opacity(0.3)
                            .foregroundColor(.gray)
                            .cornerRadius(4)

                        Rectangle()
                            .frame(width: geometry.size.width * CGFloat(progressPercentage), height: 8)
                            .foregroundColor(mission.type.color)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)

                HStack {
                    Text("\(mission.conditions.filter { $0.isCompleted() }.count)/\(mission.conditions.count) Condition Finished")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("\(Int(progressPercentage * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct AchievementSection: View {
    let missions: [Mission]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }

            CardView {
                HStack(spacing: 24) {
                    Spacer()
                    AchievementIcon(
                        icon: "timer",
                        isUnlocked: !missions.filter { $0.canCompleted }.isEmpty
                    )

                    AchievementIcon(
                        icon: "checkmark",
                        isUnlocked: missions.filter { $0.canCompleted }.count >= 3
                    )

                    AchievementIcon(
                        icon: "repeat",
                        isUnlocked: !missions.filter { $0.type == .repeat && $0.canCompleted }.isEmpty
                    )

                    AchievementIcon(
                        icon: "crown.fill",
                        isUnlocked: missions.filter { $0.type == .main && $0.canCompleted }.count >= 1
                    )
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 24)
    }
}

struct AchievementIcon: View {
    let icon: String
    let isUnlocked: Bool

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.white : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isUnlocked ? Color.cardBorder : Color.clear, lineWidth: 1)
                    )

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isUnlocked ? .gray : .white)
            }
        }
    }
}

struct StoryProgressCard: View {
    let story: Story
    @EnvironmentObject private var store: MissionStore

    var currentStoryMissions: [Mission] {
        story.missions
    }

    var progressPercentage: Double {
        guard !currentStoryMissions.isEmpty else { return 0 }
        var completedMissions = 0
        for mission in currentStoryMissions {
            if mission.canCompleted {
                completedMissions += 1
            }
        }

        return Double(completedMissions) / Double(currentStoryMissions.count)
    }

    var formatProgress: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: progressPercentage)) ?? "0%"
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(story.title)
                        .font(.headline)

                    Spacer()
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 8)
                            .opacity(0.3)
                            .foregroundColor(.gray)
                            .cornerRadius(4)

                        Rectangle()
                            .frame(width: geometry.size.width * CGFloat(progressPercentage), height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)

                HStack {
                    Text("\(currentStoryMissions.filter { $0.canCompleted }.count)/\(currentStoryMissions.count) Mission Finished")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("\(formatProgress)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct EmptyStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.gray)

            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
                .background(Color(.secondaryBackground).cornerRadius(16))
        )
    }
}

#Preview {
    JourneyView()
        .environmentObject(MissionStore())
}

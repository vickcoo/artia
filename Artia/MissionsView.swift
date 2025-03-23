//
//  TasksView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

enum MissionsSheetType: Identifiable, Equatable {
    var id: UUID { UUID() }
    case take(mission: Mission)
    case detail(mission: Mission)
}

struct MissionsView: View {
    @EnvironmentObject private var store: MissionStore
    @State var sheetType: MissionsSheetType? = nil
    @State var selectedStoryId: UUID?
    @Binding var selectedMissionId: UUID?

    var body: some View {
        VStack {
            ChipView(selectedOptionId: $selectedStoryId, options: storyChipOptions)

            ScrollView {
                LazyVStack(spacing: 16) {
                    let nextMainMissions = nextMissionFilterByStory
                    let mainMissions = currentMainMissionFilterByStory.filter {
                        $0.type == .main && $0.status == .doing
                    }
                    let sideMissions = missionsFilterByStory.filter {
                        $0.type == .side && $0.status == .doing
                    }
                    let repeatMissions = missionsFilterByStory.filter {
                        $0.type == .repeat && $0.status == .doing
                    }

                    if nextMainMissions.isEmpty == false {
                        TodoMissionList(title: i18n.newMissionAvailable.localized, missions: nextMainMissions) { mission in
                            showSheet(.take(mission: mission))
                            selectedMissionId = mission.id
                        }
                    }

                    if mainMissions.isEmpty == false {
                        MissionList(title: i18n.main.localized, missions: mainMissions) { mission in
                            showSheet(.detail(mission: mission))

                            selectedMissionId = mission.id
                        }
                    }

                    if sideMissions.isEmpty == false {
                        MissionList(title: i18n.side.localized, missions: sideMissions) { mission in
                            showSheet(.detail(mission: mission))
                            selectedMissionId = mission.id
                        }
                    }

                    if repeatMissions.isEmpty == false {
                        MissionList(title: i18n.repeat.localized, missions: repeatMissions) { mission in
                            showSheet(.detail(mission: mission))
                            selectedMissionId = mission.id
                        }
                    }

                    if missionsFilterByStory.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "tray")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)

                            if selectedStoryId != nil {
                                Text(i18n.NoMissionInThisStory.localized)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            } else {
                                Text(i18n.noMission.localized)
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
        .onChange(of: sheetType) { /* Don't remove this, this can keep showing mission detail work. */ }
        .sheet(item: $sheetType) { sheetType in
            switch sheetType {
            case let .take(mission):
                TakeMissionDetailView(mission: mission)
            case let .detail(mission):
                MissionDetailView(mission: mission)
            }
        }
    }

    var missionsFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            return store.stories.first { $0.id == selectedStoryId }?.missions ?? []
        } else {
            return store.stories.flatMap { $0.missions }
        }
    }

    var currentMainMissionFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            if let mission = store.stories.first(where: { $0.id == selectedStoryId })?.currentMainMissions {
                return [mission]
            } else {
                return []
            }
        } else {
            return store.stories.compactMap { $0.currentMainMissions }
        }
    }

    var nextMainMissionFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            if let mission = store.stories.first(where: { $0.id == selectedStoryId })?.nextMainMission {
                return [mission]
            } else {
                return []
            }
        } else {
            return store.stories.compactMap { $0.nextMainMission }
        }
    }

    var nextMissionFilterByStory: [Mission] {
        if let selectedStoryId = selectedStoryId {
            if let story = store.stories.first(where: { $0.id == selectedStoryId }) {
                return story.todoMissions
            } else {
                return []
            }
        } else {
            return store.stories.flatMap { $0.todoMissions }
        }
    }

    private var storyChipOptions: [ChipOption] {
        store.stories.map { ChipOption(id: $0.id, title: $0.title) }
    }

    private func showSheet(_ type: MissionsSheetType) {
        DispatchQueue.main.async {
            sheetType = type
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

private struct TodoMissionList: View {
    @EnvironmentObject private var store: MissionStore
    @State private var currentIndex: Int = 0
    let title: String
    let missions: [Mission]
    let tapAction: (Mission) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(missions.indices, id: \.self) { index in
                        let mission = missions[index]
                        TodoMissionCard(
                            mission: mission
                        )
                        .tag(index)
                        .foregroundStyle(Color.yellow)
                        .onTapGesture {
                            tapAction(mission)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(minHeight: 90)

                if missions.count > 1 {
                    HStack(spacing: 8) {
                        ForEach(missions.indices, id: \.self) { index in
                            Circle()
                                .fill(currentIndex == index ? Color.orange : Color.gray.opacity(0.5))
                                .frame(width: 6, height: 6)
                                .scaleEffect(currentIndex == index ? 1.2 : 1.0)
                                .animation(.spring(), value: currentIndex)
                        }
                    }
                    .padding(.bottom, 8)
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

struct TodoMissionCard: View {
    @ObservedObject var mission: Mission

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mission.type.text)
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 8)
                    .background(.orange)
                    .bold()
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .font(.caption)

                Text(mission.title)
                    .font(.headline)
                    .foregroundColor(.orange)
            }

            Text(mission.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 80, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardBorder, lineWidth: 1)
                .background(Color.secondaryBackground.cornerRadius(12))
        )
    }
}

#Preview {
    MissionsView(selectedMissionId: .constant(nil))
        .environmentObject(MissionStore())
}

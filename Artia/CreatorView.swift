//
//  CreatorView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

enum CreatorViewSheetType: Identifiable {
    var id: UUID { UUID() }
    case createMission
    case createStory
    case selectStory
    case selectMission
    case editMission(_ mission: Mission)
    case editStory(_ story: Story)
}

struct CreatorView: View {
    @EnvironmentObject private var store: MissionStore
    @State private var selectedStory: Story?
    @State private var sheetType: CreatorViewSheetType?
    @State private var selectedMission: Mission?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ], spacing: 16) {
                ShortcutButton(icon: "plus.circle.fill", title: i18n.createMission.localized, color: Color.buttonBackground) {
                    showSheet(.createMission)
                }

                ShortcutButton(icon: "book.fill", title: i18n.createStory.localized, color: Color.buttonBackground) {
                    showSheet(.createStory)
                }

                ShortcutButton(icon: "book.fill", title: i18n.editStory.localized, color: Color.buttonBackground) {
                    showSheet(.selectStory)
                }

                ShortcutButton(icon: "book.fill", title: i18n.editMission.localized, color: Color.buttonBackground) {
                    showSheet(.selectMission)
                }
            }
            .padding()
        }
        .sheet(item: $sheetType) { type in
            switch type {
            case .createMission:
                CreateMissionView()
                    .interactiveDismissDisabled()
            case .createStory:
                CreateStoryView()
                    .interactiveDismissDisabled()
            case .selectStory:
                StoryPickerView(selectedStory: $selectedStory, stories: store.stories) { story in
                    showSheet(.editStory(story))
                }
                .presentationDetents([.medium])
            case let .editStory(story):
                EditStoryView(story: story)
            case .selectMission:
                MissionPickerView(selectedMission: $selectedMission) { mission in
                    showSheet(.editMission(mission))
                }
            case let .editMission(mission):
                if let story = store.getStory(by: mission) {
                    EditMissionView(mission: mission, story: story)
                }
            }
        }
    }

    private func showSheet(_ type: CreatorViewSheetType) {
        DispatchQueue.main.async {
            sheetType = type
        }
    }
}

#Preview {
    CreatorView()
        .environmentObject(MissionStore())
}

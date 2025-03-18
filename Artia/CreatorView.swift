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
    case editStory(_ story: Story)
}

struct CreatorView: View {
    @EnvironmentObject private var store: MissionStore
    @State private var selectedStory: Story?
    @State private var sheetType: CreatorViewSheetType?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ], spacing: 16) {
                ShortcutButton(icon: "plus.circle.fill", title: "Create Mission", color: Color.buttonBackground) {
                    showSheet(.createMission)
                }

                ShortcutButton(icon: "book.fill", title: "Create Story", color: Color.buttonBackground) {
                    showSheet(.createStory)
                }

                ShortcutButton(icon: "book.fill", title: "Edit Story", color: Color.buttonBackground) {
                    showSheet(.selectStory)
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
            case .editStory(let story):
                EditStoryView(story: story)
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
}

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
    case editStory
    case editMission
}

struct CreatorView: View {
    @EnvironmentObject private var store: MissionStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreatorViewModel = .init()

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
                    showSheet(.editStory)
                }

                ShortcutButton(icon: "book.fill", title: i18n.editMission.localized, color: Color.buttonBackground) {
                    showSheet(.editMission)
                }
            }
            .padding()
        }
        .sheet(item: $viewModel.sheetType) { type in
            switch type {
            case .createMission:
                CreateMissionView(store: store)
                    .interactiveDismissDisabled()
            case .createStory:
                CreateStoryView(store: store)
                    .interactiveDismissDisabled()
            case .editStory:
                StoryPickerEditView(stories: store.stories.map { $0.copy() }) {
                    viewModel.sheetType = nil
                    dismiss()
                }
            case .editMission:
                MissionPickerView(selectedMission: $viewModel.selectedMission) {
                    viewModel.sheetType = nil
                    dismiss()
                }
            }
        }
    }

    private func showSheet(_ type: CreatorViewSheetType) {
        DispatchQueue.main.async {
            viewModel.sheetType = type
        }
    }
}

#Preview {
    CreatorView()
        .environmentObject(MissionStore())
}

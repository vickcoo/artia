//
//  EditStoryViewModel.swift
//  Artia
//
//  Created by Vick on 3/30/25.
//

import Foundation

final class EditStoryViewModel: ObservableObject {
    private let store: MissionStore
    @Published var story: Story
    @Published var title: String
    @Published var content: String
    @Published var sheetType: EditStoryViewSheetType?
    @Published var missions: [Mission]

    init(store: MissionStore, story: Story) {
        self.store = store
        self.story = story
        title = story.title
        content = story.content
        missions = story.missions
    }

    func updateStory() {
        let updatedStory = story
        updatedStory.title = title
        updatedStory.content = content
        updatedStory.missions = missions
        store.updateStory(updatedStory)
    }
}

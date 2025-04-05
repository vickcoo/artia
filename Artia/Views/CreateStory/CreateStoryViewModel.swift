//
//  CreateStoryViewModel.swift
//  Artia
//
//  Created by Vick on 3/30/25.
//

import Foundation

final class CreateStoryViewModel: ObservableObject {
    private var store: MissionStore
    @Published var title = ""
    @Published var description = ""
    @Published var showingAddMission = false
    @Published var missions: [Mission] = []
    
    init(store: MissionStore) {
        self.store = store
    }

    func deleteMission(at index: IndexSet) {
        // remove mission by index
        missions.remove(atOffsets: index)
    }

    func saveStory(completion: () -> Void) {
        let story = Story(
            title: title,
            content: description,
            missions: missions
        )

        store.addStory(story)
        completion()
    }
}

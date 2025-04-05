//
//  CreatorViewModel.swift
//  Artia
//
//  Created by Vick on 4/1/25.
//

import Foundation

final class CreatorViewModel: ObservableObject {
    @Published var selectedStory: Story?
    @Published var sheetType: CreatorViewSheetType?
    @Published var selectedMission: Mission?
}

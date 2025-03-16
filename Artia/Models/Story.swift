//
//  Story.swift
//  Artia
//
//  Created by Vick on 3/15/25.
//

import Foundation

struct Story: Identifiable, Equatable {
    let id: UUID
    var title: String
    var content: String

    var missions: [Mission] = []

    init(id: UUID = UUID(), title: String, content: String, missions: [Mission]) {
        self.id = id
        self.title = title
        self.content = content
        self.missions = missions
    }
}

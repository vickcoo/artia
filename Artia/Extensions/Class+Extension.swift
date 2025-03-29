//
//  Class+Extension.swift
//  Artia
//
//  Created by Vick on 3/23/25.
//

extension Mission {
    func copy() -> Mission {
        let mission = Mission(
            id: id,
            title: title,
            description: description,
            status: status,
            type: type,
            conditions: conditions.map { $0 },
            rewards: rewards.map({ $0 })
        )
        return mission
    }
}

extension Story {
    func copy() -> Story {
        let story = Story(
            id: id,
            title: title,
            content: content,
            missions: missions.map { $0.copy() }
        )
        return story
    }
}

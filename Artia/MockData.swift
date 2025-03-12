//
//  MockData.swift
//  Artia
//
//  Created by Vick on 3/11/25.
//

import Foundation

enum MockData {
    static let task: Mission = .init(
        title: "Defeat the Dragon King",
        description: "Venture into the Dragon's Lair and defeat the legendary Dragon King. Required level: 50+",
        status: .todo,
        type: .main,
        story: Story(
            title: "Main Quest",
            content: "The fate of the kingdom rests in your hands"
        ),
        conditions: [
            MissionCondition(title: "Capture Battle Scene", strategy: ImageConditionStrategy(goal: 3, images: [])),
            MissionCondition(title: "Walk Steps", strategy: HealthKitConditionStrategy(goal: 1000, healthType: .steps, progress: 0)),
        ],
        rewards: [
            MissionReward(title: "A Sword", description: "Drop by Dragon King"),
        ]
    )

    static let tasks: [Mission] = [
        Mission(
            title: "Defeat the Dragon King",
            description: "Venture into the Dragon's Lair and defeat the legendary Dragon King. Required level: 50+",
            status: .todo,
            type: .main,
            story: Story(
                title: "Main Quest",
                content: "The fate of the kingdom rests in your hands"
            ),
            conditions: [
                MissionCondition(title: "Capture Battle Scene", strategy: ImageConditionStrategy(goal: 3, images: [])),
            ],
            rewards: []
        ),
        Mission(
            title: "Collect 10 Magic Crystals",
            description: "Search the Crystal Cave for rare magic crystals needed for the ancient ritual",
            status: .todo,
            type: .side,
            story: Story(
                title: "Side Quest",
                content: "The Wizard needs these for research"
            ),
            conditions: [
                MissionCondition(title: "Crystal Collection Photos", strategy: ImageConditionStrategy(goal: 5, images: [])),
            ],
            rewards: []
        ),
        Mission(
            title: "Daily Training",
            description: "Complete your daily combat training to maintain your skills",
            status: .todo,
            type: .repeat,
            story: Story(
                title: "Daily Quest",
                content: "Practice makes perfect"
            ),
            conditions: [
                MissionCondition(title: "Workout Tracking", strategy: HealthKitConditionStrategy(goal: 300, healthType: .calories, progress: 0)),
            ],
            rewards: []
        ),
        Mission(
            title: "Save the Lost Village",
            description: "Investigate the mysterious disappearances in Shadowvale and protect the villagers",
            status: .todo,
            type: .main,
            story: Story(
                title: "Main Quest",
                content: "Dark forces are at work"
            ),
            conditions: [
                MissionCondition(title: "Evidence Photos", strategy: ImageConditionStrategy(goal: 5, images: [])),
                MissionCondition(title: "Physical Condition Monitor", strategy: HealthKitConditionStrategy(goal: 500, healthType: .calories, progress: 0)),
            ],
            rewards: []
        ),
        Mission(
            title: "Enchant Your Weapon",
            description: "Visit the blacksmith to enhance your weapon with magical properties",
            status: .todo,
            type: .side,
            story: Story(
                title: "Equipment Quest",
                content: "Upgrade your gear"
            ),
            conditions: [
                MissionCondition(title: "Weapon Upgrade Proof", strategy: ImageConditionStrategy(goal: 1, images: [])),
            ],
            rewards: []
        ),
    ]
}

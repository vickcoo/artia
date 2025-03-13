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
            content: "The fate of the kingdom rests in your hands",
            missions: []
        ),
        conditions: [
            ImageCondition(title: "Capture Battle Scene", goal: 1, value: [])
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
                content: "The fate of the kingdom rests in your hands",
                missions: []
            ),
            conditions: [
                ImageCondition(title: "Capture Battle Scene", goal: 3, value: [])
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
                content: "The Wizard needs these for research",
                missions: []
            ),
            conditions: [
                ImageCondition(title: "Crystal Collection Photos", goal: 5, value: [])
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
                content: "Practice makes perfect",
                missions: []
            ),
            conditions: [
                HealthKitCondition(healthType: .calories, title: "Workout Tracking", value: 0, goal: 300)
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
                content: "Dark forces are at work",
                missions: []
            ),
            conditions: [
                ImageCondition(title: "Evidence Photos", goal: 5, value: []),
                HealthKitCondition(healthType: .calories, title: "Physical Condition Monitor", value: 0, goal: 500)
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
                content: "Upgrade your gear",
                missions: []
            ),
            conditions: [
                ImageCondition(title: "Weapon Upgrade Proof", goal: 1, value: [])
            ],
            rewards: []
        ),
    ]
}

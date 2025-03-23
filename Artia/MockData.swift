//
//  MockData.swift
//  Artia
//
//  Created by Vick on 3/11/25.
//

import Foundation

enum MockData {
    static let story: Story = .init(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        title: "The Dragon's Menace",
        content: "The fate of the kingdom rests in your hands",
        missions: [
            Mission(
                title: "Defeat the Dragon King",
                description: "Venture into the Dragon's Lair and defeat the legendary Dragon King. Required level: 50+",
                status: .doing,
                type: .main,
                conditions: [
                    ImageCondition(title: "Capture Battle Scene", goal: 3, value: []),
                ],
                rewards: [
                    MissionReward(title: "Dragon's Bane", description: "Legendary sword dropped by Dragon King"),
                ]
            ),
            Mission(
                title: "Save the Lost Village",
                description: "Investigate the mysterious disappearances in Shadow Valley and protect the villagers",
                status: .todo,
                type: .main,
                conditions: [
                    ImageCondition(title: "Evidence Photos", goal: 5, value: []),
                    HealthKitCondition(healthType: .calories, title: "Physical Monitoring", value: 0, goal: 500),
                ],
                rewards: [
                    MissionReward(title: "Village Elder's Amulet", description: "An ancient protective charm"),
                ]
            )
        ]
    )
    static let stories: [Story] = [
        Story(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            title: "The Dragon's Menace",
            content: "The fate of the kingdom rests in your hands",
            missions: [
                Mission(
                    title: "Defeat the Dragon King",
                    description: "Venture into the Dragon's Lair and defeat the legendary Dragon King. Required level: 50+",
                    status: .doing,
                    type: .main,
                    conditions: [
                        ImageCondition(title: "Capture Battle Scene", goal: 3, value: []),
                    ],
                    rewards: [
                        MissionReward(title: "Dragon's Bane", description: "Legendary sword dropped by Dragon King"),
                    ]
                ),
                Mission(
                    title: "Save the Lost Village",
                    description: "Investigate the mysterious disappearances in Shadow Valley and protect the villagers",
                    status: .doing,
                    type: .main,
                    conditions: [
                        ImageCondition(title: "Evidence Photos", goal: 5, value: []),
                        HealthKitCondition(healthType: .calories, title: "Physical Monitoring", value: 0, goal: 500),
                    ],
                    rewards: [
                        MissionReward(title: "Village Elder's Amulet", description: "An ancient protective charm"),
                    ]
                )
            ]
        ),
        Story(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            title: "The Wizard's Request",
            content: "The wizard needs these items for his research",
            missions: [
                Mission(
                    title: "Collect 10 Magic Crystals",
                    description: "Search for rare magic crystals needed for an ancient ritual in the Crystal Cave",
                    status: .todo,
                    type: .side,
                    conditions: [
                        ImageCondition(title: "Crystal Collection Photos", goal: 5, value: []),
                    ],
                    rewards: [
                        MissionReward(title: "Wizard's Gratitude", description: "A magical enhancement for your equipment"),
                    ]
                )
            ]
        ),
        Story(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            title: "Training Regimen",
            content: "Practice makes perfect",
            missions: [
                Mission(
                    title: "Daily Training",
                    description: "Complete daily combat training to maintain your skills",
                    status: .todo,
                    type: .repeat,
                    conditions: [
                        HealthKitCondition(healthType: .calories, title: "Exercise Tracking", value: 0, goal: 300),
                    ],
                    rewards: [
                        MissionReward(title: "Experience Points", description: "Gain additional XP for your character"),
                    ]
                )
            ]
        ),
        Story(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            title: "The Blacksmith's Challenge",
            content: "Upgrade your equipment",
            missions: [
                Mission(
                    title: "Enchant Your Weapon",
                    description: "Visit the blacksmith to add magical properties to your weapon",
                    status: .todo,
                    type: .side,
                    conditions: [
                        ImageCondition(title: "Weapon Upgrade Proof", goal: 1, value: []),
                    ],
                    rewards: [
                        MissionReward(title: "Elemental Infusion", description: "Your weapon now deals additional elemental damage"),
                    ]
                )
            ]
        ),
    ]

    static let mission: Mission = .init(
        title: "Defeat the Dragon King",
        description: "Venture into the Dragon's Lair and defeat the legendary Dragon King. Required level: 50+",
        status: .doing,
        type: .main,
        conditions: [
            ImageCondition(title: "Capture Battle Scene", goal: 1, value: []),
        ],
        rewards: [
            MissionReward(title: "Dragon's Bane", description: "Legendary sword dropped by Dragon King"),
        ]
    )

    static let missions: [Mission] = [
        Mission(
            title: "Defeat the Dragon King",
            description: "Venture into the Dragon's Lair and defeat the legendary Dragon King. Required level: 50+",
            status: .doing,
            type: .main,
            conditions: [
                ImageCondition(title: "Capture Battle Scene", goal: 3, value: []),
            ],
            rewards: [
                MissionReward(title: "Dragon's Bane", description: "Legendary sword dropped by Dragon King"),
            ]
        ),
        Mission(
            title: "Collect 10 Magic Crystals",
            description: "Search for rare magic crystals needed for an ancient ritual in the Crystal Cave",
            status: .todo,
            type: .side,
            conditions: [
                ImageCondition(title: "Crystal Collection Photos", goal: 5, value: []),
            ],
            rewards: [
                MissionReward(title: "Wizard's Gratitude", description: "A magical enhancement for your equipment"),
            ]
        ),
        Mission(
            title: "Daily Training",
            description: "Complete daily combat training to maintain your skills",
            status: .todo,
            type: .repeat,
            conditions: [
                HealthKitCondition(healthType: .calories, title: "Exercise Tracking", value: 0, goal: 300),
            ],
            rewards: [
                MissionReward(title: "Experience Points", description: "Gain additional XP for your character"),
            ]
        ),
        Mission(
            title: "Save the Lost Village",
            description: "Investigate the mysterious disappearances in Shadow Valley and protect the villagers",
            status: .todo,
            type: .main,
            conditions: [
                ImageCondition(title: "Evidence Photos", goal: 5, value: []),
                HealthKitCondition(healthType: .calories, title: "Physical Monitoring", value: 0, goal: 500),
            ],
            rewards: [
                MissionReward(title: "Village Elder's Amulet", description: "An ancient protective charm"),
            ]
        ),
        Mission(
            title: "Enchant Your Weapon",
            description: "Visit the blacksmith to add magical properties to your weapon",
            status: .todo,
            type: .side,
            conditions: [
                ImageCondition(title: "Weapon Upgrade Proof", goal: 1, value: []),
            ],
            rewards: [
                MissionReward(title: "Elemental Infusion", description: "Your weapon now deals additional elemental damage"),
            ]
        ),
    ]
}

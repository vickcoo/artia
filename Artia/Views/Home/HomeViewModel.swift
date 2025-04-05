//
//  HomeViewModel.swift
//  Artia
//
//  Created by Vick on 4/1/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var selectedTabType: TabType = .user
    @Published var selectedTab: Tab = .missions
}

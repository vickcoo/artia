import Foundation
import SwiftUI

enum TabType {
    case user
    case creator
}

enum Tab: String {
    // User
    case missions
    case journey

    // Creator
    case creator
    
    var title: String {
        switch self {
        case .missions:
            return i18n.missions.localized
        case .journey:
            return i18n.journey.localized
        case .creator:
            return i18n.creator.localized
        }
    }
}

struct HomeView: View {
    @EnvironmentObject private var store: MissionStore

    @State var selectedTabType: TabType = .user
    @State var selectedTab: Tab = .missions
    
    @State private var missionsSheetType: MissionsSheetType? = nil

    @State private var selectedMissionId: UUID?

    var body: some View {
        VStack {
            TopTabView(
                selectedTabType: $selectedTabType,
                selectedTab: $selectedTab
            )

            TabView(selection: $selectedTab) {
                JourneyView()
                    .tag(Tab.journey)

                MissionsView(selectedMissionId: $selectedMissionId)
                    .tag(Tab.missions)

                CreatorView()
                    .tag(Tab.creator)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedTabType) {
                switch selectedTabType {
                case .user:
                    selectedTab = .missions
                case .creator:
                    selectedTab = .creator
                }
            }
            .onChange(of: selectedTab) {
                switch selectedTab {
                case .journey:
                    selectedTabType = .user
                case .missions:
                    selectedTabType = .user
                case .creator:
                    selectedTabType = .creator
                }
            }

            Spacer()
        }
        .background(
            AnimationMeshGradientView()
                .ignoresSafeArea()
        )
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct TopTabView: View {
    @Binding var selectedTabType: TabType
    @Binding var selectedTab: Tab

    var body: some View {
        TabView(selection: $selectedTabType) {
            HStack {
                Spacer()
                tabButton(title: i18n.journey.localized, image: "map.fill", tab: .journey)
                Spacer()
                tabButton(title: i18n.missions.localized, image: "transmission", tab: .missions)
                Spacer()
            }
            .tag(TabType.user)

            HStack {
                Spacer()
                tabButton(title: i18n.creator.localized, image: "theatermasks.fill", tab: .creator)
                Spacer()
            }
            .tag(TabType.creator)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 80)
        .padding([.leading, .trailing])
    }

    private func tabButton(title: String, image: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            let isSelected = selectedTab == tab
            VStack(spacing: 3) {
                Image(systemName: image)
                    .imageScale(isSelected ? .large : .medium)
                Text(title)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .padding()
            .foregroundColor(isSelected ? Color.tintPrimary : Color.tintSecondary)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MissionStore())
}

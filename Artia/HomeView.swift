import Foundation
import SwiftUI

enum TabType {
    case user
    case creator
}

enum Tab: String {
    // User
    case missions = "Missions"
    case journey = "Journey"

    // Creator
    case creator = "Creator"
}

struct HomeView: View {
    @EnvironmentObject private var store: MissionStore

    @State var selectedTabType: TabType = .user
    @State var selectedTab: Tab = .missions
    @State var selectedStoryId: UUID? = nil

    private var storyChipOptions: [ChipOption] {
        store.stories.map { ChipOption(id: $0.id, title: $0.title) }
    }

    var body: some View {
        VStack {
            TopTabView(
                selectedTabType: $selectedTabType,
                selectedTab: $selectedTab
            )

            if selectedTab == .missions {
                ChipView(selectedOptionId: $selectedStoryId, options: storyChipOptions)
            }

            TabView(selection: $selectedTab) {
                JourneyView()
                    .tag(Tab.journey)

                MissionsView(selectedStoryId: selectedStoryId)
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
                tabButton(title: Tab.journey.rawValue, image: "map.fill", tab: .journey)
                Spacer()
                tabButton(title: Tab.missions.rawValue, image: "transmission", tab: .missions)
                Spacer()
            }
            .tag(TabType.user)

            HStack {
                Spacer()
                tabButton(title: Tab.creator.rawValue, image: "theatermasks.fill", tab: .creator)
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

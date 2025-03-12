import Foundation
import SwiftUI

enum TabType {
    case user
    case creator
}

enum Tab: String {
    case tasks = "Tasks"
    case creator = "Creator"
}

struct HomeView: View {
    @EnvironmentObject private var store: MissionStore

    @State var selectedTabType: TabType = .user
    @State var selectedTab: Tab = .tasks

    var body: some View {
        VStack {
            TopTabView(
                selectedTabType: $selectedTabType,
                selectedTab: $selectedTab
            )

            TabView(selection: $selectedTab) {
                MissionsView()
                    .tag(Tab.tasks)

                CreatorView()
                    .tag(Tab.creator)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedTabType) {
                switch selectedTabType {
                case .user:
                    selectedTab = .tasks
                case .creator:
                    selectedTab = .creator
                }
            }
            .onChange(of: selectedTab) {
                switch selectedTab {
                case .tasks:
                    selectedTabType = .user
                case .creator:
                    selectedTabType = .creator
                }
            }

            Spacer()
        }
        .background(Color(.primaryBackground))
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
                adventureTabButtons
                Spacer()
            }
            .tag(TabType.user)

            HStack {
                Spacer()
                creatorTabButton
                Spacer()
            }
            .tag(TabType.creator)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 80)
        .padding([.leading, .trailing])
        .background(Color(.tabBarBackground))
    }

    private var adventureTabButtons: some View {
        tabButton(title: Tab.tasks.rawValue, image: "transmission", tab: .tasks)
    }

    private var creatorTabButton: some View {
        tabButton(title: Tab.creator.rawValue, image: "theatermasks.fill", tab: .creator)
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
            .foregroundColor(isSelected ? .brown : .gray)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MissionStore())
}

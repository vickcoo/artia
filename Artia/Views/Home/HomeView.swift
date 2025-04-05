import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: MissionStore
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            TopTabView(
                selectedTabType: $viewModel.selectedTabType,
                selectedTab: $viewModel.selectedTab
            )

            TabView(selection: $viewModel.selectedTab) {
                JourneyView()
                    .tag(Tab.journey)

                MissionsView(store: store)
                    .tag(Tab.missions)

                CreatorView()
                    .tag(Tab.creator)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: viewModel.selectedTabType) {
                switch viewModel.selectedTabType {
                case .user:
                    viewModel.selectedTab = .missions
                case .creator:
                    viewModel.selectedTab = .creator
                }
            }
            .onChange(of: viewModel.selectedTab) {
                switch viewModel.selectedTab {
                case .journey:
                    viewModel.selectedTabType = .user
                case .missions:
                    viewModel.selectedTabType = .user
                case .creator:
                    viewModel.selectedTabType = .creator
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

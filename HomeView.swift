struct HomeView: View {
    @EnvironmentObject private var store: MissionStore

    @State var selectedTabType: TabType = .adventure
    @State var selectedTab: Tab = .tasks

    var body: some View {
        VStack {
            TopTabView(
                selectedTabType: $selectedTabType,
                selectedTab: $selectedTab
            )
            
            if selectedTab == .tasks {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.missions) { mission in
                            MissionCard(mission: mission)
                        }
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .background(Color(.primaryBackground))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct MissionCard: View {
    let mission: Mission
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mission.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(mission.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
} 
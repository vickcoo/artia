import SwiftUI

struct EditStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var store: MissionStore
    @StateObject private var viewModel: EditStoryViewModel
    var completion: () -> Void = {}

    init(store: MissionStore, story: Story, completion: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: EditStoryViewModel(store: store, story: story))
        self.completion = completion
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(i18n.info.localized) {
                        TextField(i18n.title.localized, text: $viewModel.title)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.content.localized) {
                        TextEditor(text: $viewModel.content)
                            .frame(minHeight: 100)
                    }
                    .listRowBackground(Color(.section))

                    Section {
                        MissionList(missions: $viewModel.missions, story: $viewModel.story)

                        Button(action: {
                            viewModel.sheetType = .addMission
                        }) {
                            Label(i18n.addMission.localized, systemImage: "plus.circle")
                                .foregroundStyle(.black)
                        }
                    } header: {
                        HStack {
                            Text(i18n.missions.localized)

                            Spacer()

                            EditButton()
                                .foregroundStyle(.black)
                                .font(.footnote)
                        }
                    }
                    .listRowBackground(Color(.section))
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(Color.primaryBackground)

                Spacer()

                RichButton(title: i18n.done.localized, color: .buttonBackground, disabled: false) {
                    viewModel.updateStory()
                    completion()
                }
                .padding()
            }
            .navigationTitle(i18n.editStory.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text(i18n.cancel.localized)
                            .tint(.black)
                    }
                }
            }
        }
        .sheet(item: $viewModel.sheetType) { sheetType in
            switch sheetType {
            case .addMission:
                StoryCreateMissionView(missions: $viewModel.missions)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
            }
        }
    }
}

private struct MissionList: View {
    @EnvironmentObject private var store: MissionStore
    @Environment(\.editMode) private var editMode
    @Binding var missions: [Mission]
    @Binding var story: Story

    var body: some View {
        List {
            ForEach($missions, id: \.id) { $mission in
                NavigationLink {
                    EditMissionView(store: store, mission: mission, story: story)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text(mission.type.text)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black)
                            .clipShape(Capsule())

                        Text(mission.title)
                    }
                    .foregroundStyle(.black)
                }
            }
            .onMove { indexSet, destination in
                missions.move(fromOffsets: indexSet, toOffset: destination)
            }
            .onDelete { indexSet in
                missions.remove(atOffsets: indexSet)
            }
        }
    }
}

enum EditStoryViewSheetType: Identifiable {
    var id: UUID { UUID() }
    case addMission
}

#Preview {
    EditStoryView(store: MissionStore(), story: MockData.story)
        .environmentObject(MissionStore())
}

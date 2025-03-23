import SwiftUI

struct EditStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var store: MissionStore
    @State private var story: Story
    @State private var title: String
    @State private var content: String
    @State private var sheetType: EditStoryViewSheetType?
    @State private var missions: [Mission]
    var completion: () -> Void = {}

    init(story: Story, completion: @escaping () -> Void = {}) {
        self.story = story
        title = story.title
        content = story.content
        sheetType = nil
        missions = story.missions
        self.completion = completion
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(i18n.info.localized) {
                        TextField(i18n.title.localized, text: $title)
                    }
                    .listRowBackground(Color(.section))

                    Section(i18n.content.localized) {
                        TextEditor(text: $content)
                            .frame(minHeight: 100)
                    }
                    .listRowBackground(Color(.section))

                    Section {
                        MissionList(missions: $missions, story: $story)

                        Button(action: {
                            sheetType = .addMission
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
                    let updatedStory = story
                    updatedStory.title = title
                    updatedStory.content = content
                    updatedStory.missions = missions
                    store.updateStory(updatedStory)
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
        .sheet(item: $sheetType) { sheetType in
            switch sheetType {
            // case let .editMission(mission):
            //     EditMissionView(mission: mission, story: story)
            case .addMission:
                StoryCreateMissionView(missions: $missions)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
            }
        }
    }
}

private struct MissionList: View {
    @Environment(\.editMode) private var editMode
    @Binding var missions: [Mission]
    @Binding var story: Story

    var body: some View {
        List {
            ForEach($missions, id: \.id) { $mission in
                NavigationLink {
                    EditMissionView(mission: mission, story: story)
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
    EditStoryView(story: MockData.story)
}

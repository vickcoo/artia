import SwiftUI

struct EditStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var store: MissionStore
    @ObservedObject private var story: Story
    @State private var title: String
    @State private var content: String
    @State private var sheetType: EditStoryViewSheetType?

    init(story: Story) {
        self.story = story
        title = story.title
        content = story.content
        sheetType = nil
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
                        List {
                            ForEach($story.missions, id: \.id) { $mission in
                                Button {
                                    if editMode?.wrappedValue.isEditing == false {
                                        sheetType = .editMission(mission: mission)
                                    }
                                } label: {
                                    HStack {
                                        Text(mission.title)
                                        Spacer()
                                        if editMode?.wrappedValue.isEditing == false {
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .foregroundStyle(.black)
                                }
                            }
                            .onMove { indexSet, destination in
                                story.missions.move(fromOffsets: indexSet, toOffset: destination)
                            }
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
                    store.updateStory(updatedStory)
                    dismiss()
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
            case let .editMission(mission):
                EditMissionView(mission: mission, story: story)
            }
        }
    }
}

enum EditStoryViewSheetType: Identifiable {
    var id: UUID { UUID() }
    case editMission(mission: Mission)
}

#Preview {
    EditStoryView(story: MockData.story)
}

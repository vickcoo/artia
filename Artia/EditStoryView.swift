import SwiftUI

struct EditStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: MissionStore
    @State private var story: Story
    @State private var title: String
    @State private var content: String
    @State private var sheetType: EditStoryViewSheetType?

    init(story: Story) {
        _story = State(initialValue: story)
        _title = State(initialValue: story.title)
        _content = State(initialValue: story.content)
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

                    Section(i18n.missions.localized) {
                        ForEach($story.missions) { $mission in
                            Button {
                                sheetType = .editMission(mission: mission)
                            } label: {
                                HStack {
                                    Text(mission.title)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                            }
                        }
                        .onMove { indexSet, destination in
                            story.missions.move(fromOffsets: indexSet, toOffset: destination)
                        }
                    }
                    .listRowBackground(Color(.section))
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(Color.primaryBackground)

                Spacer()

                RichButton(title: i18n.done.localized, color: .buttonBackground, disabled: false) {
                    var updatedStory = story
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
                    Button(i18n.cancel.localized) {
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .sheet(item: $sheetType) { sheetType in
            switch sheetType {
            case .editMission(let mission):
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

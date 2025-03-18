import SwiftUI

struct EditStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: MissionStore
    @State private var story: Story
    @State private var title: String
    @State private var content: String

    init(story: Story) {
        _story = State(initialValue: story)
        _title = State(initialValue: story.title)
        _content = State(initialValue: story.content)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Info") {
                        TextField("Title", text: $title)
                    }
                    .listRowBackground(Color(.section))

                    Section("Content") {
                        TextEditor(text: $content)
                            .frame(minHeight: 100)
                    }
                    .listRowBackground(Color(.section))

                    Section("Missions") {
                        ForEach($story.missions) { $mission in
                            Text(mission.title)
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

                RichButton(title: "Done", color: .buttonBackground, disabled: false) {
                    var updatedStory = story
                    updatedStory.title = title
                    updatedStory.content = content
                    store.updateStory(updatedStory)
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Edit Story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    EditStoryView(story: MockData.story)
}

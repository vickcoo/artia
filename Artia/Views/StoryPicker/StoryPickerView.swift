//
//  StoryPickerView.swift
//  Artia
//
//  Created by Vick on 3/23/25.
//

import SwiftUI

struct StoryPickerView: View {
    @Binding var selectedStory: Story?
    let stories: [Story]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(stories) { story in
                    Button {
                        selectedStory = story
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            Text(story.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .foregroundColor(.primary)
                    }
                    
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .navigationTitle(i18n.selectStory.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(i18n.cancel.localized) {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }
}

struct StoryPickerEditView: View {
    @EnvironmentObject private var store: MissionStore
    let stories: [Story]
    @Environment(\.dismiss) private var dismiss
    var completion: () -> Void = {}

    var body: some View {
        NavigationStack {
            List {
                ForEach(stories) { story in
                    NavigationLink {
                        EditStoryView(store: store, story: story) {
                            completion()
                        }
                        .navigationBarBackButtonHidden()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            Text(story.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .navigationTitle(i18n.selectStory.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(i18n.cancel.localized) {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }
}

#Preview {
    StoryPickerView(selectedStory: .constant(nil), stories: MockData.stories)
}
#Preview {
    StoryPickerEditView(stories: MockData.stories)
}

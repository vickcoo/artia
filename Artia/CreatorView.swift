//
//  CreatorView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

struct CreatorView: View {
    @EnvironmentObject private var store: MissionStore
    @State private var showCreateMissionView = false
    @State private var showCreateStoryView = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ], spacing: 16) {
                ShortcutButton(icon: "plus.circle.fill", title: "Create Mission", color: Color.buttonBackground) {
                    showCreateMissionView = true
                }

                ShortcutButton(icon: "book.fill", title: "Create Story", color: Color.buttonBackground) {
                    showCreateStoryView = true
                }
            }
            .padding()
        }
        .sheet(isPresented: $showCreateStoryView) {
            CreateStoryView()
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showCreateMissionView) {
            CreateMissionView()
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    CreatorView()
}

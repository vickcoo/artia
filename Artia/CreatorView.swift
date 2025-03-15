//
//  CreatorView.swift
//  Artia
//
//  Created by Vick on 3/12/25.
//

import SwiftUI

struct ShortcutButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)

                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.buttonBackground)
            .cornerRadius(16)
        }
    }
}

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
                ShortcutButton(icon: "plus.circle.fill", title: "Create Mission", color: .brown.opacity(0.1)) {
                    showCreateMissionView = true
                }

                ShortcutButton(icon: "book", title: "Create Story", color: .brown.opacity(0.1)) {
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

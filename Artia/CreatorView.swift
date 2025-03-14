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
                    .foregroundColor(.black)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(color)
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

                ShortcutButton(icon: "plus.circle.fill", title: "新增任務", color: .brown.opacity(0.1)) {
                    // Action
                }

                ShortcutButton(icon: "arrow.triangle.branch", title: "新增任務線", color: .brown.opacity(0.1)) {
                    // Action
                }
            }
            .padding()
        }
        .background(.primaryBackground)
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

//
//  DropdownChipView.swift
//  Artia
//
//  Created by Vick on 3/16/25.
//

import Foundation
import SwiftUI

struct DropdownChipOption<T: Identifiable & Hashable>: Identifiable {
    let id: T.ID
    let title: String
    let value: T
}

struct Dropdown<T: Identifiable & Hashable>: View {
    @Binding var selectedOption: T?
    let options: [DropdownChipOption<T>]
    let title: String
    let allOptionTitle: String

    var body: some View {
        Menu {
            Button(action: {
                selectedOption = nil
            }) {
                HStack {
                    Text(allOptionTitle)
                    if selectedOption == nil {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }

            ForEach(options) { option in
                Button(action: {
                    selectedOption = option.value
                }) {
                    HStack {
                        Text(option.title)
                        if selectedOption?.id == option.id {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedOption != nil ?
                    options.first(where: {
                        $0.value.id == selectedOption?.id
                    })?.title ?? title : title)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.cardBorder, lineWidth: 1)
                    .background(
                        Color.white.opacity(0.6).cornerRadius(20)
                    )
            )
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
}

#Preview {
    var storyDropdownOptions: [DropdownChipOption<Story>] {
        MockData.stories.map { story in
            DropdownChipOption(id: story.id, title: story.title, value: story)
        }
    }
    Dropdown(
        selectedOption: .constant(nil),
        options: storyDropdownOptions,
        title: "Select Story",
        allOptionTitle: "All"
    )
    .environmentObject(MissionStore())
}

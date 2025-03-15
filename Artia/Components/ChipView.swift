//
//  ChipOption.swift
//  Artia
//
//  Created by Vick on 3/15/25.
//

import Foundation
import SwiftUI

struct ChipOption: Identifiable {
    let id: UUID
    let title: String
}

struct ChipView: View {
    @Binding var selectedOptionId: UUID?
    let options: [ChipOption]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: {
                    selectedOptionId = nil
                }) {
                    Text("All")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundColor(selectedOptionId == nil ? .white : .primary)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.cardBorder, lineWidth: 1)
                                .background(
                                    (selectedOptionId == nil ? Color.black.opacity(0.7) : Color.white.opacity(0.6)).cornerRadius(20)
                                )
                        )
                }

                ForEach(options) { option in
                    Button(action: {
                        selectedOptionId = option.id
                    }) {
                        Text(option.title)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedOptionId == option.id ? .white : .primary)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.clear, lineWidth: 1)
                                    .background(
                                        Color(
                                            selectedOptionId == option.id ? Color.black.opacity(0.7) : Color.white.opacity(0.6)
                                        ).cornerRadius(20)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    let id = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    ChipView(selectedOptionId: .constant(id), options: [
        ChipOption(id: id, title: "Swift"),
        ChipOption(id: UUID(), title: "Kotlin"),
        ChipOption(id: UUID(), title: "Dart"),
    ])
}

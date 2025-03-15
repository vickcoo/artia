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
                        .background(selectedOptionId == nil ? Color.brown : Color.gray.opacity(0.3))
                        .foregroundColor(selectedOptionId == nil ? .white : .primary)
                        .cornerRadius(20)
                }

                ForEach(options) { option in
                    Button(action: {
                        selectedOptionId = option.id
                    }) {
                        Text(option.title)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedOptionId == option.id ? Color.brown : Color.gray.opacity(0.3))
                            .foregroundColor(selectedOptionId == option.id ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

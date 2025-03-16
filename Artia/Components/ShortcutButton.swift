//
//  ShortcutButton.swift
//  Artia
//
//  Created by Vick on 3/16/25.
//

import SwiftUI

struct ShortcutButton: View {
    let icon: String
    let title: String
    let color: Color
    var disabled: Bool = false
    let action: () -> Void

    var finalColor: Color {
        if disabled {
            return Color.buttonDisableBackground
        } else {
            return color
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [finalColor.opacity(0.7), finalColor.opacity(0.8)]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 180
                )
                .cornerRadius(16)

                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    Spacer()
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(height: 60)
            .shadow(color: finalColor.opacity(0.4), radius: 10, x: 0, y: 4)
        }
    }
}

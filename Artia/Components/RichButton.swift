//
//  RichButton.swift
//  Artia
//
//  Created by Vick on 3/16/25.
//

import SwiftUI

struct RichButton: View {
    let title: String
    let color: Color
    var icon: String? = nil
    let disabled: Bool
    let action: () -> Void
    @State private var size: CGSize = .zero

    struct IconPosition: Hashable {
        let offset: CGSize
        let size: CGFloat
        let opacity: Double
        let rotation: Double
    }

    var positions: [IconPosition] {
        return [
            // 文字周圍的裝飾圖示（較小且較透明）
            // IconPosition(offset: CGSize(width: -size.width/6, height: -size.height/2.8), size: 6, opacity: 0.15, rotation: 25),
            // IconPosition(offset: CGSize(width: size.width/5, height: -size.height/3.2), size: 5, opacity: 0.12, rotation: -15),
            // IconPosition(offset: CGSize(width: 0, height: -size.height/2.5), size: 4, opacity: 0.1, rotation: 0),
            // IconPosition(offset: CGSize(width: size.width/8, height: -size.height/2.2), size: 5, opacity: 0.13, rotation: 30),

            // 左側區域圖示
            IconPosition(offset: CGSize(width: -size.width / 2.2, height: -5), size: 14, opacity: 0.3, rotation: 15),
            IconPosition(offset: CGSize(width: -size.width / 2.8, height: size.height / 4), size: 11, opacity: 0.25, rotation: -10),
            IconPosition(offset: CGSize(width: -size.width / 3.2, height: -size.height / 2.5), size: 9, opacity: 0.2, rotation: 25),

            // 右側區域圖示
            IconPosition(offset: CGSize(width: size.width / 2.5, height: 8), size: 13, opacity: 0.3, rotation: -20),
            IconPosition(offset: CGSize(width: size.width / 2.2, height: -size.height / 3), size: 10, opacity: 0.22, rotation: 15),
            IconPosition(offset: CGSize(width: size.width / 3.5, height: size.height / 2.8), size: 12, opacity: 0.28, rotation: -5),

            // 更遠的背景圖示
            IconPosition(offset: CGSize(width: -size.width / 1.6, height: -size.height / 1.8), size: 8, opacity: 0.15, rotation: 30),
            IconPosition(offset: CGSize(width: size.width / 1.9, height: size.height / 1.9), size: 7, opacity: 0.18, rotation: -25),
            IconPosition(offset: CGSize(width: size.width / 1.7, height: -size.height / 2.2), size: 9, opacity: 0.16, rotation: 10),
            IconPosition(offset: CGSize(width: -size.width / 2.1, height: size.height / 1.7), size: 8, opacity: 0.17, rotation: -15),

            // 額外的裝飾圖示
            IconPosition(offset: CGSize(width: -size.width / 4.2, height: -size.height / 1.9), size: 6, opacity: 0.12, rotation: 45),
            IconPosition(offset: CGSize(width: size.width / 3.8, height: -size.height / 1.7), size: 7, opacity: 0.14, rotation: -35),
            IconPosition(offset: CGSize(width: size.width / 4.5, height: size.height / 1.8), size: 6, opacity: 0.13, rotation: 20),
            IconPosition(offset: CGSize(width: -size.width / 3.6, height: size.height / 2.1), size: 7, opacity: 0.15, rotation: -40),

            // 更小的遠處圖示
            IconPosition(offset: CGSize(width: size.width / 1.5, height: 0), size: 5, opacity: 0.1, rotation: 60),
            IconPosition(offset: CGSize(width: -size.width / 1.4, height: -size.height / 4), size: 5, opacity: 0.11, rotation: -50),
        ]
    }

    var x: CGFloat {
        return -(size.width / 2)
    }

    var y: CGFloat {
        return -(size.height / 2)
    }

    var finalColor: Color {
        if disabled {
            return Color.buttonDisableBackground
        } else {
            return color
        }
    }

    var finalIcon: String {
        guard let icon = icon else { return "" }
        if disabled {
            return "xmark"
        } else {
            return icon
        }
    }

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [finalColor.opacity(0.7), finalColor.opacity(0.8)]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 180
                )
                .cornerRadius(16)

                // if let icon {
                //     ForEach(positions, id: \.self) { position in
                //         Image(systemName: finalIcon)
                //             .resizable()
                //             .scaledToFit()
                //             .frame(width: position.size)
                //             .foregroundColor(finalColor.opacity(position.opacity))
                //             .rotationEffect(.degrees(position.rotation))
                //             .offset(position.offset)
                //     }
                // }

                HStack {
                    Spacer()
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()

                GeometryReader { proxy in
                    HStack {}
                        .onAppear {
                            size = proxy.size
                        }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(height: 60)
            .shadow(color: finalColor.opacity(0.4), radius: 10, x: 0, y: 4)
        }
        .disabled(disabled)
    }
}

//
//  CardView.swift
//  Artia
//
//  Created by Vick on 3/15/25.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 2)
                    .background(Color.secondaryBackground.cornerRadius(16))
            )
    }
}

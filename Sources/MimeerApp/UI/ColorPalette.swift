//
//  ColorPalette.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/15/23.
//

import SwiftUI

struct ColorPalette: View {
    static let defaultColorOptions = [
        Color.red,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .indigo,
        .purple,
        .pink,
    ]

    @Binding var color: Color

    let columns = [
        GridItem(.adaptive(minimum: 48, maximum: 48))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Self.defaultColorOptions, id: \.hashValue) { colorOption in
                Button {
                    color = colorOption
                } label: {
                    colorOption
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
            #if os(iOS)
                ColorPicker("Custom Color", selection: $color, supportsOpacity: false)
                    .scaleEffect(1.5)
                    .labelsHidden()
            #endif
        }
    }
}

#Preview {
    ColorPalette(color: .constant(.green))
}

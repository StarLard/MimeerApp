//
//  IconPalette.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/15/23.
//

import MimeerKit
import SwiftUI

struct IconPalette: View {
    @Binding var icon: SFSymbol
    var icons: [SFSymbol]
    var categories: [SFSymbol.Category]

    init(icon: Binding<SFSymbol>, icons: [SFSymbol] = SFSymbol.all) {
        self._icon = icon
        self.icons = icons
        self.categories = Set(icons.map(\.category)).sorted { lhs, rhs in
            lhs.displayOrder < rhs.displayOrder
        }
    }

    var body: some View {
        ForEach(categories) { category in
            Section {
                CategoryPalette(icon: $icon, icons: category.symbols)
            } header: {
                HStack {
                    Text(category.localizedTitle)
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }

    struct CategoryPalette: View {
        @Binding var icon: SFSymbol
        var icons: [SFSymbol]
        var iconSize: CGFloat = 36

        let columns = [
            GridItem(.adaptive(minimum: 48, maximum: 48))
        ]

        var body: some View {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(icons) { symbol in
                    Button {
                        icon = symbol
                    } label: {
                        symbol.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: iconSize, maxHeight: iconSize)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    IconPalette(icon: .constant(.airplane), icons: SFSymbol.Category.devices.symbols)
}

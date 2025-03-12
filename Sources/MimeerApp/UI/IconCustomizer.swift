//
//  IconCustomizer.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/15/23.
//

import MimeerKit
import SwiftUI

struct IconCustomizer: View {
    @Binding var icon: SFSymbol
    @Binding var color: Color
    @State var searchText: String = ""
    @Environment(\.dismiss) var dismss

    var body: some View {
        SearchView(icon: $icon, color: $color, searchText: $searchText)
            .navigationTitle("Icon")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismss()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Icons")
    }
}

extension IconCustomizer {
    fileprivate struct SearchView: View {
        @Binding var icon: SFSymbol
        @Binding var color: Color
        @Binding var searchText: String
        @Environment(\.isSearching) var isSearching
        @Environment(\.dismissSearch) var dismissSearch

        var filteredSymbols: [SFSymbol] {
            Set(SFSymbol.all)
                .filter { symbol in
                    guard !searchText.isEmpty else { return true }
                    let sanitizedSearchText = searchText.lowercased()
                    let nameMatches = symbol.systemName.contains(sanitizedSearchText)
                    let categoryMatches = symbol.category.localizedTitle.lowercased().contains(
                        sanitizedSearchText)
                    return nameMatches || categoryMatches
                }
                .sorted(using: SortDescriptor(\SFSymbol.systemName, order: .reverse))
        }

        var body: some View {
            ScrollView {
                LazyVStack(spacing: 24) {
                    IconPreview(color: color, icon: icon)
                        .padding(.top)

                    if !isSearching {
                        ColorPalette(color: $color)

                        IconPalette(icon: $icon, icons: SFSymbol.all)
                    } else {
                        IconPalette(icon: $icon, icons: filteredSymbols)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: icon) {
                searchText = ""
                dismissSearch()
            }
        }
    }
}

#if DEBUG
    struct IconCustomizerPreviewContainer: View {
        @State var icon = SFSymbol.leafFill
        @State var color = Color.green

        var body: some View {
            IconCustomizer(icon: $icon, color: $color)
        }
    }

    #Preview {
        NavigationStack {
            IconCustomizerPreviewContainer()
        }
    }
#endif

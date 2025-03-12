//
//  IconPreview.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/15/23.
//

import MimeerKit
import SwiftUI

struct IconPreview: View {
    var color: Color
    var icon: SFSymbol
    var size: Size = .medium

    enum Size {
        case small
        case medium
        case large

        var frame: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 72
            case .large: return 108
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 16
            case .large: return 24
            }
        }

        var padding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 16
            case .large: return 24
            }
        }
    }

    var body: some View {
        color
            .frame(width: size.frame, height: size.frame)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .overlay {
                icon.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .padding(size.padding)
            }
    }
}

#Preview {
    Group {
        IconPreview(color: .green, icon: .leafFill, size: .large)
        IconPreview(color: .green, icon: .leafFill)
        IconPreview(color: .green, icon: .leafFill, size: .small)
    }
}

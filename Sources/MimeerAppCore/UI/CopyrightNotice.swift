//
//  CopyrightNotice.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/17/23.
//

import SwiftUI

struct CopyrightNotice: View {
    @Environment(\.calendar) private var calendar

    var body: some View {
        Text(
            "Copyright © \(year == initialYear ? String(year) : "\(initialYear)-\(String(year))") Caleb Friden. All rights reserved."
        )
        .font(.footnote)
    }
    private let initialYear = 2023
    private var year: Int { calendar.component(.year, from: date) }
    @Environment(\.date) private var date
}

#Preview {
    CopyrightNotice()
}

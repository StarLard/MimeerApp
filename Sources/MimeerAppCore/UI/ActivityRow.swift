//
//  ActivityRow.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/15/23.
//

import MimeerKit
import SwiftData
import SwiftUI

struct ActivityRow: View {
    var activity: Activity

    var body: some View {
        HStack {
            IconPreview(color: Color(activity.color), icon: activity.icon, size: .small)

            Text(activity.title)
        }
    }
}

#if DEBUG
    #Preview {
        List {
            ForEach(Mocks.activities) { activity in
                ActivityRow(activity: activity)
            }
        }
        .modelContainer(.shared)
    }
#endif

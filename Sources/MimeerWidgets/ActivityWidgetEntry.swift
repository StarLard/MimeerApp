//
//  ActivityWidgetEntry.swift
//  Mimeer
//
//  Created by Caleb Friden on 8/21/23.
//

import Foundation
import WidgetKit

struct ActivityWidgetEntry: TimelineEntry {
    var date: Date
    var snapshot: ActivitySnapshot?
}

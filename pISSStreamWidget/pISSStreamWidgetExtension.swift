//
//  pISSStreamWidgetExtension.swift
//  pISSStream
//
//  Created by Neo Werling on 31.05.25.
//

import WidgetKit
import SwiftUI

@main
struct pISSStreamWidgetExtension: Widget {
    let kind: String = "pISSStreamWidget"
    var body: some WidgetConfiguration {
        
        StaticConfiguration(
            kind: kind,
            provider: pISSStreamWidgetProvider(),
            content: { pISSStreamWidgetView(entry: $0) }
        )
        .configurationDisplayName("pISSStreamWidget")
        .description("shows the International Space Station's urine tank's capacity in real-time")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}

#Preview(as: .systemSmall) {
    pISSStreamWidgetExtension()
} timeline: {
    pISSStreamWidgetEntry(date: .now, percentage: 11)
    pISSStreamWidgetEntry(date: .now + 1, percentage: 12)
}

#Preview(as: .systemMedium) {
    pISSStreamWidgetExtension()
} timeline: {
    pISSStreamWidgetEntry(date: .now, percentage: 11)
    pISSStreamWidgetEntry(date: .now + 1, percentage: 12)
}

#Preview(as: .systemLarge) {
    pISSStreamWidgetExtension()
} timeline: {
    pISSStreamWidgetEntry(date: .now, percentage: 11)
    pISSStreamWidgetEntry(date: .now + 1, percentage: 12)
}

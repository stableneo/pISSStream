//
//  Providerr.swift
//  pISSStream
//
//  Created by Neo Werling on 31.05.25.
//

import WidgetKit

struct pISSStreamWidgetProvider: TimelineProvider {
    private let placeholderEntry = pISSStreamWidgetEntry(
        date: Date(),
        percentage: 0
    )
    
    func placeholder(in context: Context) -> pISSStreamWidgetEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (pISSStreamWidgetEntry) -> ()) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<pISSStreamWidgetEntry>) -> Void) {
        let currentDate = Date()
        var entries: [pISSStreamWidgetEntry] = []
        
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let percentage: Int8 = 11
            let entry = pISSStreamWidgetEntry(date: entryDate, percentage: percentage)
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
}

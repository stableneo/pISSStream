//
//  View.swift
//  pISSStream
//
//  Created by Neo Werling on 31.05.25.
//

import WidgetKit
import SwiftUI

struct pISSStreamWidgetView: View {
    
    var entry: pISSStreamWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "drop")
                Text("")
            }
            .font(.title3)
            .bold()
            .padding(.bottom, 8)
            
            Text(String(entry.percentage))
                .font(.title)
            
            Spacer()
            
            HStack{
                Spacer()
                Text("**Last Update:** \\(entry.date.formatted(.dateTime))")
                    .font(.caption2)
                
            }
        }
        .foregroundStyle(.white)
        
        // 4.
        .containerBackground(for: .widget){
            Color.cyan
        }
    }
}

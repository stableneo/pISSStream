//
//  ContentView.swift
//  pISSStreamWatchApp Watch App
//
//  Created by durul dalkanat on 5/20/25.
//

import SwiftUI

struct pISSStreamWatchAppView: View {
    @EnvironmentObject var appState: AppStateViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                Circle()
                    .fill(appState.getStatusColor())
                    .frame(width: 8, height: 8)

                Text(appState.getStatusText())
                    .font(.caption2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            VStack(spacing: 4) {
                Text("Waste Tank")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Text(appState.pissAmount)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.pissYellowDark)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.pissYellowLight.opacity(0.2))
            )

            Text("🧑🏽‍🚀🚽")
                .font(.title3)
                .padding(.top, 6)
        }
        .padding()
    }
}

#Preview {
    pISSStreamWatchAppView()
}

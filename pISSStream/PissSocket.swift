//
//  PissSocket.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import BackgroundTasks
import LightstreamerClient
import SwiftUI
import os

actor PissActor {
    let logger = Logger(
        subsystem: "social.bsky.jaennaet.pISSStream", category: "PissActor")

    class SubscriptionDelegateImpl: SubscriptionDelegate {
        private let logger = Logger(
            subsystem: "social.bsky.jaennaet.StreamingPiss",
            category: "SubscriptionDelegate")
        
        let (stream, continuation) = AsyncStream.makeStream(of: String.self)
        private let onConnectionStatusChange: (Bool) -> Void

        init(appState: AppState, onConnectionStatusChange: @escaping (Bool) -> Void) {
            self.onConnectionStatusChange = onConnectionStatusChange
            logger.debug("SubscriptionDelegateImpl.init()")
        }

        func subscription(
            _ subscription: Subscription, didUpdateItem itemUpdate: ItemUpdate
        ) {
            let newValue = (itemUpdate.value(withFieldName: "Value") ?? "N/A") + "%"
            logger.debug("received value update: \(newValue)")
            continuation.yield(newValue)
        }

        func subscription(
            _ subscription: Subscription,
            didClearSnapshotForItemName itemName: String?, itemPos: UInt
        ) {}

        func subscription(
            _ subscription: Subscription, didLoseUpdates lostUpdates: UInt,
            forCommandSecondLevelItemWithKey key: String
        ) {}

        func subscription(
            _ subscription: Subscription, didFailWithErrorCode code: Int,
            message: String?, forCommandSecondLevelItemWithKey key: String
        ) {}

        func subscription(
            _ subscription: Subscription,
            didEndSnapshotForItemName itemName: String?,
            itemPos: UInt
        ) {}

        func subscription(
            _ subscription: Subscription, didLoseUpdates lostUpdates: UInt,
            forItemName itemName: String?, itemPos: UInt
        ) {
            logger.error("Lost updates: \(lostUpdates) for item: \(itemName ?? "unknown")")
            onConnectionStatusChange(false)
        }

        func subscriptionDidRemoveDelegate(_ subscription: Subscription) {}

        func subscriptionDidAddDelegate(_ subscription: Subscription) {}

        func subscriptionDidSubscribe(_ subscription: Subscription) {}

        func subscription(
            _ subscription: Subscription, didFailWithErrorCode code: Int,
            message: String?
        ) {}

        func subscriptionDidUnsubscribe(_ subscription: Subscription) {}

        func subscription(
            _ subscription: Subscription,
            didReceiveRealFrequency frequency: RealMaxFrequency?
        ) {}
    }

    let client: LightstreamerClient = LightstreamerClient(
        serverAddress: "https://push.lightstreamer.com",
        adapterSet: "ISSLIVE")
    
    let stream: AsyncStream<String>
    init(appState: AppState) {
        logger.debug("PissActor.init()")
        client.connect()
        let pissTankSub = Subscription(
            subscriptionMode: .MERGE, items: ["NODE3000005"],
            fields: ["Value"])
        
        let delegate = SubscriptionDelegateImpl(
            appState: appState,
            onConnectionStatusChange: { isConnected in
                Task { @MainActor in
                    appState.isConnected = isConnected
                }
            }
        )
        
        self.stream = delegate.stream
        pissTankSub.addDelegate(delegate)
        client.subscribe(pissTankSub)
    }

    func pissStream() -> AsyncStream<String> {
        return stream
    }
}


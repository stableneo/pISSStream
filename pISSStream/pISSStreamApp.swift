import BackgroundTasks
import LightstreamerClient
import SwiftUI
import os

actor PissActor {
	let logger = Logger(
		subsystem: "social.bsky.jaennaet.pISSStream", category: "PissActor")

	class SubscriptionDelegateImpl: SubscriptionDelegate {
		let logger = Logger(
			subsystem: "social.bsky.jaennaet.StreamingPiss",
			category: "SubscriptionDelegate")

		let (stream, continuation) = AsyncStream.makeStream(of: String.self)

		init() {
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
		) {}

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
	init() {
		logger.debug("PissActor.init()")
		client.connect()
		let pissTankSub = Subscription(
			subscriptionMode: .MERGE, items: ["NODE3000005"],
			fields: ["Value" /* , "TimeStamp" */])
		let delegate = SubscriptionDelegateImpl()
		self.stream = delegate.stream
		pissTankSub.addDelegate(delegate)
		client.subscribe(pissTankSub)
	}

	func pissStream() -> AsyncStream<String> {
		return stream
	}
}

@MainActor
class AppState: ObservableObject {
	@Published var pissAmount: String = "N/A"
	private let logger = Logger(
		subsystem: "social.bsky.jaennaet.pISSStream", category: "AppState")
	private let pissActor = PissActor()

	init() {
		startPissStream()
	}

	private func startPissStream() {
		Task {
			logger.debug("starting pissActor.pissStream() reader")
			for await amount in await pissActor.pissStream() {
				self.pissAmount = amount
			}
		}
	}
}

@main
struct piSSStreamApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject private var appState = AppState()

	var body: some Scene {
		MenuBarExtra {
			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}
		} label: {
			PissLabel(amount: appState.pissAmount)
		}
	}
}

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		NSApp.setActivationPolicy(.accessory)
	}
}

struct PissLabel: View {
	let amount: String

	var body: some View {
		Text("🧑🏽‍🚀🚽\(amount)")
			.font(.system(size: 12, weight: .bold, design: .default))
	}
}

extension Color {
	static let pissYellowLight = Color(red: 0.95, green: 0.85, blue: 0.2)
	static let pissYellowDark = Color(red: 0.7, green: 0.6, blue: 0.1)
}

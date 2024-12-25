//
//  AppDelegate.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import SwiftUI

#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		// accessory: the application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be activated programmatically or by clicking on one of its windows.
        NSApp.setActivationPolicy(.accessory)
    }
}
#endif

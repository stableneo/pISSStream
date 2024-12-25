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
        NSApp.setActivationPolicy(.accessory)
    }
}
#endif

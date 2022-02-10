//
//  bindedDevicesApp.swift
//  Shared
//
//  Created by Sasha Booharin on 09.02.2022.
//

import SwiftUI

@main
struct bindedDevicesApp: App {
    let assembly = BindedDevicesAssembly()

    var body: some Scene {
        WindowGroup {
            assembly.createBindedDevicesView()
        }
    }
}

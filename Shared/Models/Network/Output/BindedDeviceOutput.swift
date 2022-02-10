//
//  BindedDeviceOutput.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

struct BindedDeviceOutput: Decodable {
    let agent: Agent?
}

struct Agent: Decodable {
    let display: String?
}

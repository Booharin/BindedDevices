//
//  BindedDevicesResponse.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

struct BindedDevicesResponse: Decodable {
    let status: String?
    let data: [BindedDeviceOutput]?
    let actualTimestamp: Int?
}

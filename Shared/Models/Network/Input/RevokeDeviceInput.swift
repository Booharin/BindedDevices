//
//  RevokeDeviceInput.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

struct RevokeDeviceInput: Codable {
    var meta: ServerMetaParameters
    var data: RevokeDeviceParameters

    init(meta: ServerMetaParameters, data: RevokeDeviceParameters) {
        self.meta = meta
        self.data = data
    }
}

struct RevokeDeviceParameters: Codable {
    var refreshToken: String?

    init(refreshToken: String?) {
        self.refreshToken = refreshToken
    }
}

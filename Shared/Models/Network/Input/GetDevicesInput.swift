//
//  GetDevicesInput.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

struct GetDevicesInput: Codable {
    init(meta: ServerMetaParameters) {
        self.meta = meta
    }
    
    /// Meta object registration request.
    let meta: ServerMetaParameters
}

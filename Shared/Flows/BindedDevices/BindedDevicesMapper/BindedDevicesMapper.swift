//
//  BindedDevicesMapper.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

final class BindedDevicesMapper {}

extension BindedDevicesMapper: BindedDevicesMapperProtocol {

    func getBindedDeviceItems(from models: [BindedDeviceOutput]?) -> [BindedDeviceItem]? {
        models?.compactMap {
            BindedDeviceItem(
                title: $0.agent?.display
            )
        }
    }
}

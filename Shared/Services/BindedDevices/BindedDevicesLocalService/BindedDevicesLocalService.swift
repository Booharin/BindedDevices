//
//  BindedDevicesLocalService.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

final class BindedDevicesLocalService: BindedDevicesLocalServiceProtocol {
    var devices: [BindedDeviceOutput]? {
        get {
            CoreDataManager.shared.get(
                with: BindedDevice.self,
                predicate: nil
            )?
            .compactMap { $0.transform() }
        }
        set {
            newValue?.forEach { device in
                CoreDataManager.shared.save { context in
                    let object = BindedDevice(context: context)
                    object.title = device.agent?.display
                    object.token = device.token
                }
            }
        }
    }
}

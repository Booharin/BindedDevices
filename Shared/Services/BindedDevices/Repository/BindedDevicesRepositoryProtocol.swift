//
//  BindedDevicesRepositoryProtocol.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import RxSwift

protocol BindedDevicesRepositoryProtocol {
    var devices: [BindedDeviceOutput]? { get set }
    func downloadDevices() -> Single<BindedDevicesResponse>
}

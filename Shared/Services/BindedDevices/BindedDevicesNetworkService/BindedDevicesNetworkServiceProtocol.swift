//
//  BindedDevicesNetworkServiceProtocol.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

import RxSwift

protocol BindedDevicesNetworkServiceProtocol {
    func downloadDevices(token: String) -> Single<BindedDevicesResponse>
    func revokeDevice(token: String, deviceToken: String) -> Single<BindedDevicesResponse>
}

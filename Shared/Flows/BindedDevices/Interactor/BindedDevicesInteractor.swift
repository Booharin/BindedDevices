//
//  BindedDevicesInteractor.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import RxSwift

final class BindedDevicesInteractor {

    private let bindedDevicesRepository: BindedDevicesRepositoryProtocol

    init(bindedDevicesRepository: BindedDevicesRepositoryProtocol) {
        self.bindedDevicesRepository = bindedDevicesRepository
    }
}

extension BindedDevicesInteractor: BindedDevicesInteractorProtocol {

    var bindedDevices: [BindedDeviceOutput]? {
        bindedDevicesRepository.devices
    }

    func downloadDevices() -> Single<BindedDevicesResponse> {
        return self.bindedDevicesRepository.downloadDevices()
    }
}

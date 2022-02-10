//
//  BindedDevicesRepository.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import RxSwift

final class BindedDevicesRepository {
    private let networkDataSource: BindedDevicesNetworkServiceProtocol
    private var localDataSource: BindedDevicesLocalServiceProtocol

    private var token: String {
        return ""
    }

    init(
        networkDataSource: BindedDevicesNetworkServiceProtocol,
        localDataSource: BindedDevicesLocalServiceProtocol
    ) {
        self.networkDataSource = networkDataSource
        self.localDataSource = localDataSource
    }
}

extension BindedDevicesRepository: BindedDevicesRepositoryProtocol {

    var devices: [BindedDeviceOutput]? {
        get {
            localDataSource.devices
        }
        set {
            localDataSource.devices = newValue
        }
    }

    func downloadDevices() -> Single<BindedDevicesResponse> {
        return self.networkDataSource.downloadDevices(token: token)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .do(onSuccess: { [weak self] response in
                self?.devices = response.data
            })
    }

    func revokeDevice(with deviceToken: String) -> Single<BindedDevicesResponse> {
        return self.networkDataSource.revokeDevice(token: token, deviceToken: deviceToken)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .do(onSuccess: { [weak self] response in
                self?.devices = response.data
            })
    }
}

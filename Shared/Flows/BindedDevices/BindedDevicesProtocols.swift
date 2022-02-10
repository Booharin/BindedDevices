//
//  BindedDevicesProtocol.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import RxSwift

// MARK: - View

protocol BindedDevicesViewOutput {
    var deviceItems: [BindedDeviceItem]? { get }
    func viewDidAppear()
}

protocol BindedDevicesViewInput: AnyObject {

}

// MARK: - Interactor

protocol BindedDevicesInteractorProtocol {
    var bindedDevices: [BindedDeviceOutput]? { get }
    func downloadDevices() -> Single<BindedDevicesResponse>
}

// MARK: - Router

protocol BindedDevicesRouterInput {

}

protocol BindedDevicesMapperProtocol {
    func getBindedDeviceItems(from models: [BindedDeviceOutput]?) -> [BindedDeviceItem]?
}

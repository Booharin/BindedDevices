//
//  BindedDevicesPresenter.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import Combine
import RxSwift

final class BindedDevicesPresenter: ObservableObject {
    @Published var deviceItems: [BindedDeviceItem]? = []

    private let interactor: BindedDevicesInteractorProtocol
    private let router: BindedDevicesRouterInput
    private let mapper: BindedDevicesMapperProtocol

    private var disposables = DisposeBag()

    init(
        interactor: BindedDevicesInteractorProtocol,
        router: BindedDevicesRouterInput,
        mapper: BindedDevicesMapperProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    private func getBindedDeviceItems() {
        self.interactor.downloadDevices()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.deviceItems = self?.mapper.getBindedDeviceItems(from: response.data)
                }
            ).disposed(by: self.disposables)
    }
}

extension BindedDevicesPresenter: BindedDevicesViewOutput {

    func viewDidAppear() {
        deviceItems = mapper.getBindedDeviceItems(from: interactor.bindedDevices)
        getBindedDeviceItems()
    }
}

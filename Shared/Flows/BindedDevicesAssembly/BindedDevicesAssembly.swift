//
//  BindedDevicesAssembly.swift
//  bindedDevices (iOS)
//
//  Created by Sasha Booharin on 09.02.2022.
//

import SwiftUI

final class BindedDevicesAssembly {

    func createBindedDevicesView() -> some View {
        let repository = BindedDevicesRepository(
            networkDataSource: BindedDevicesNetworkService(
                baseURL: ManualURL(urlString: ""),
                isMock: true),
            localDataSource: BindedDevicesLocalService()
        )

        let interactor = BindedDevicesInteractor(bindedDevicesRepository: repository)
        let router = BindedDevicesRouter()
        let mapper = BindedDevicesMapper()

        let presenter = BindedDevicesPresenter(
            interactor: interactor,
            router: router,
            mapper: mapper
        )

        return BindedDevicesView(output: presenter)
    }
}

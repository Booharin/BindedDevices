//
//  BindedDevicesNetworkService.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

import RxSwift
import Moya

final class BindedDevicesNetworkService: BindedDevicesNetworkServiceProtocol {
    private let provider: MoyaProvider<BindedDevicesTarget>
    private let baseURL: BaseURL
    private let isMock: Bool

    init(baseURL: BaseURL, isMock: Bool) {
        self.baseURL = baseURL
        self.isMock = isMock
        self.provider = MoyaProvider<BindedDevicesTarget>()
    }

    func downloadDevices(token: String) -> Single<BindedDevicesResponse> {
        let inputs = GetDevicesInput(meta: ServerMetaParameters())
        guard let encodedData = try? JSONEncoder().encode(inputs)
        else {
            assertionFailure("Не удалось сериализовать данные")
            return .never()
        }

        let target = BindedDevicesTarget(
            baseURL: self.baseURL,
            headers: [
                "Autorization": "Bearer \(token)"
            ],
            bindedDevicesRequestType: .getDevices(input: encodedData)
        )

        return self.provider.rx.request(
            target,
            type: BindedDevicesResponse.self
        ) { result -> Swift.Result<BindedDevicesResponse, Error> in

            //MARK: - Mock

            if self.isMock {
                guard let path = Bundle.main.path(forResource: "GetDeviceBindingList", ofType: "json"),
                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                else {
                    return .failure(SystemError.unknown(message: "Error"))
                }

                do {
                    let response = try JSONDecoder().decode(BindedDevicesResponse.self, from: data)
                    return .success(response)
                } catch {
                    return .failure(SystemError.unknown(message: "Error"))
                }
            }

            switch result {
            case .success(let value):
                guard value.statusCode == 200,
                      let response = try? JSONDecoder().decode(BindedDevicesResponse.self, from: value.data)
                else {
                    return .failure(SystemError.unknown(message: "Error"))
                }

                return .success(response)
            case .failure:
                return .failure(SystemError.unknown(message: "Error"))
            }
        }
    }

    func revokeDevice(token: String, deviceToken: String) -> Single<BindedDevicesResponse> {
        let revokeDeviceParameters = RevokeDeviceParameters(refreshToken: deviceToken)
        let inputs = RevokeDeviceInput(meta: ServerMetaParameters(), data: revokeDeviceParameters)
        guard let encodedData = try? JSONEncoder().encode(inputs)
        else {
            assertionFailure("Не удалось сериализовать данные")
            return .never()
        }

        let target = BindedDevicesTarget(
            baseURL: self.baseURL,
            headers: [
                "Autorization": "Bearer \(token)"
            ],
            bindedDevicesRequestType: .revokeDevice(input: encodedData)
        )

        return self.provider.rx.request(
            target,
            type: BindedDevicesResponse.self
        ) { result -> Swift.Result<BindedDevicesResponse, Error> in
            switch result {
            case .success(let value):
                guard value.statusCode == 200,
                      let response = try? JSONDecoder().decode(BindedDevicesResponse.self, from: value.data)
                else {
                    return .failure(SystemError.unknown(message: "Error"))
                }

                return .success(response)
            case .failure:
                return .failure(SystemError.unknown(message: "Error"))
            }
        }
    }
}

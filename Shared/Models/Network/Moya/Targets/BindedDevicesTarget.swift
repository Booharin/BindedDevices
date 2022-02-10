//
//  BindedDevicesTarget.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

import Moya

struct BindedDevicesTarget: TargetType {

    enum BindedDevicesRequestType {
        case getDevices(input: Data)
        case revokeDevice(input: Data)
    }

    var bindedDevicesRequestType: BindedDevicesRequestType

    var baseURL: URL
    
    var path: String {
        switch self.bindedDevicesRequestType {
        case .getDevices:
            return "passport/adapter/oauth2/tokens"
        case .revokeDevice:
            return "passport/adapter/oauth2/revoke"
        }
    }
    
    var method: Moya.Method {
        switch self.bindedDevicesRequestType {
        case .getDevices,
             .revokeDevice:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        let urlParameters = self.urlParameters
        let bodyParameters = self.bodyParameters
        
        switch (!urlParameters.isEmpty, !bodyParameters.isEmpty) {
        case (true, false):
            return .requestParameters(parameters: urlParameters, encoding: URLEncoding(destination: .queryString))
        case (false, true):
            return .requestData(bodyParameters)
        case (true, true):
            return .requestCompositeData(bodyData: bodyParameters, urlParameters: urlParameters)
        case (false, false):
            return .requestPlain
        }
    }

    var urlParameters: [String: Any] {
        switch self.bindedDevicesRequestType {
        case .getDevices,
             .revokeDevice:
            return ["realm": "/b2c/person"]
        }
    }

    var bodyParameters: Data {
        switch self.bindedDevicesRequestType {
        case .getDevices(let input),
             .revokeDevice(let input):
            return input
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var headers: [String : String]?

    init(
        baseURL: BaseURL,
        headers: [String: String]?,
        bindedDevicesRequestType: BindedDevicesRequestType
    ) {
        self.baseURL = baseURL.url
        self.headers = headers
        self.bindedDevicesRequestType = bindedDevicesRequestType
    }
}

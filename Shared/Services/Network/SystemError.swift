//
//  SystemError.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

public enum SystemError: Error {
    case unauthorized
    case unknown(message: String)
    
    public static func currentLocalizedDescription(_ error: Error) -> String {
        switch error {
        case let systemError as SystemError:
            switch systemError {
            case let .unknown(message):
                return message
            case .unauthorized:
                return error.localizedDescription
            }
        default:
            return error.localizedDescription
        }
    }
    
}

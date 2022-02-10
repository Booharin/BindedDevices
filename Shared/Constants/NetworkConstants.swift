//
//  NetworkConstants.swift
//  bindedDevices (iOS)
//
//  Created by Alexandr Booharin on 10.02.2022.
//

public enum NetworkConstants {
    public static let bearer = "Bearer"
    public static let sid = "sid"
    public static let channel = "mobile"

    public enum Header {
        public enum MobileSDK {
            public static let name = "GPB-mobileSdkData"
        }

        public enum Platform {
            public static let name = "platform"
            public static let value = "IOS"
        }

        public enum Version {
            public static let name = "version"
        }
    }

    public enum Status {
        public static let success = "success"
        public static let warning = "warning"
        public static let error = "error"
        public static let needConfirmOTP = "needConfirmOTP"
        public static let needConfirm = "needConfirm"
    }
}

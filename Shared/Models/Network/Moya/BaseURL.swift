//
//  BundleSettingsURL.swift
//  SharedServices
//
//  Created by Попов Владислав on 16.09.2020.
//

import Foundation

private enum Constants {
    static let emptyURL = URL(fileURLWithPath: "")
}

public protocol BaseURL {
    var url: URL { get }
}

public class ManualURL: BaseURL {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public init(urlString: String) {
        self.url = URL(string: urlString) ?? Constants.emptyURL
    }
}

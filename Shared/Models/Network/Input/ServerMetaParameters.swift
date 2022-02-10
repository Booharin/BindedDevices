//
//  ServerMetaParameters.swift
//  SharedServices
//
//  Created by Попов Владислав on 16.09.2020.
//  Copyright © 2020 GazPromBank. All rights reserved.
//

/// Common entity meta registration request.
public struct ServerMetaParameters: Codable {

    /// Channel name.
    public var channel = NetworkConstants.channel
    
    public init() {}
    
}

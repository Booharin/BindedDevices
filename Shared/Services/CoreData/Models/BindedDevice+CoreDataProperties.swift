//
//  BindedDevice+CoreDataProperties.swift
//  
//
//  Created by Alexandr Booharin on 13.02.2022.
//
//

import Foundation
import CoreData


extension BindedDevice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BindedDevice> {
        return NSFetchRequest<BindedDevice>(entityName: "BindedDevice")
    }

    @NSManaged public var title: String?
    @NSManaged public var token: String?

}

extension BindedDevice {
    @discardableResult
    func transform() -> BindedDeviceOutput? {
        return BindedDeviceOutput(
            token: self.token,
            agent: Agent(display: self.title)
        )
    }
}

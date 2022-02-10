//
//  BindedDevice+CoreDataProperties.swift
//  
//
//  Created by Alexandr Booharin on 10.02.2022.
//
//

import Foundation
import CoreData


extension BindedDevice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BindedDevice> {
        return NSFetchRequest<BindedDevice>(entityName: "BindedDevice")
    }

    @NSManaged public var title: String?

}

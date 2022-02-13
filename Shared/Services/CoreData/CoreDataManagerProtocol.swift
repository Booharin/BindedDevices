//
//  CoreDataManagerProtocol.swift
//  Telecard
//
//  Created by Rustam Nurgaliev on 26/03/2020.
//  Copyright © 2020 GazPromBank. All rights reserved.
//

import CoreData

public protocol CoreDataManagerProtocol {
    /// Remove object from core data
    ///
    /// - Parameter managedObject: object type
    func delete<T>(managedObject: T) where T: NSManagedObject
    
    /// Get array of object filtered with predicate and sorted
    ///
    /// - Parameters:
    ///   - type: object type
    ///   - predicate: request predicate
    ///   - sortDescriptors: sorting
    /// - Returns: result arr
    func get<T: NSManagedObject>(
        with type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) -> [T]?
    
    /// Update array of object filtered with predicate and sorted
    ///
    /// - Parameters:
    ///   - type: object type
    ///   - predicate: request predicate
    ///   - block: closure with filtered array with predicate
    ///   - completion: completion closure
    /// - Returns: result arr
    func update<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        block: @escaping ([T]?) -> Void,
        completion: VoidClosure?
    ) where T: NSManagedObject

    /// Remove objects from core data
    ///
    /// - Parameters:
    ///   - type: object type
    ///   - predicate: request predicate
    func delete<T>(with type: T.Type, predicate: NSPredicate?) where T: NSManagedObject
}

public extension NSManagedObjectContext {
    func get<T>(with request: NSFetchRequest<NSFetchRequestResult>) -> [T]? where T: NSManagedObject {
        do {
            return try self.fetch(request) as? [T]
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
}

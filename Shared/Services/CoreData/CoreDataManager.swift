//
//  CoreDataManager.swift
//  Notifications
//
//  Created by Rustam Nurgaliev on 26.07.2021.
//  Copyright © 2021 GazPromBank. All rights reserved.
//

import CoreData

public typealias VoidClosure = () -> Void

public final class CoreDataManager: CoreDataManagerProtocol {
    
    public static let shared = CoreDataManager()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.backgroundContextDidSave(notification:)),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: self.backgroundContext
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Core Data stack
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: CoreDataManager.self)
        guard let bundleURL = bundle.url(forResource: "bindedDevices", withExtension: "momd"),
              let object = NSManagedObjectModel(contentsOf: bundleURL)
        else {
            assertionFailure("Не удалось получить NSManagedObjectModel для PCMCoreData")
            return NSManagedObjectModel()
        }
        
        return object
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return self.createPersistentStoreCoordinator(isFirstTry: true)
    }()
    
    private func createPersistentStoreCoordinator(isFirstTry: Bool) -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("bindedDevices.SingleViewCoreData.sqlite")
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            let mOptions = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: url,
                options: mOptions
            )
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            if isFirstTry {
                self.removePersistentStore(coordinator: coordinator, url: url)
                return self.createPersistentStoreCoordinator(isFirstTry: false)
            } else {
                abort()
            }
        }
        return coordinator
    }
    
    private func removePersistentStore( coordinator: NSPersistentStoreCoordinator, url: URL?) {
        guard let storeURL = url else { return }
        do {
            try coordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
        } catch {
            abort()
        }
    }
    
    private lazy var mainContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveBackgroundContext() {
        guard self.backgroundContext.hasChanges else { return }
        
        do {
            try self.backgroundContext.save()
        } catch {
            let nserror = error as NSError
            assertionFailure("Ошибка при сохранении контекста: \(nserror), \(nserror.userInfo)")
        }
    }
    
    @objc private func backgroundContextDidSave(notification: Notification) {
        self.mainContext.perform { [weak self] in
            self?.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    // MARK: - DataManager protocol
    
    public func get<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T]? where T: NSManagedObject {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        var result: [T]?
        self.mainContext.performAndWait { [weak self] in
            result = self?.mainContext.get(with: request)
        }
        
        return result
    }
    
    public func getAndWait<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]? = nil,
        completion: ([T]?) -> Void
    ) where T: NSManagedObject {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        var result: [T]?
        self.mainContext.performAndWait { [weak self] in
            guard let self = self else { return }
            
            result = self.mainContext.get(with: request)
            completion(result)
        }
    }
    
    public func save(
        _ block: @escaping (_ context: NSManagedObjectContext) -> Void,
        completion: VoidClosure? = nil) {
            self.backgroundContext.performAndWait { [weak self] in
                guard let self = self else { return }
                
                block(self.backgroundContext)
                self.saveBackgroundContext()
                completion?()
            }
        }
    
    public func update<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        block: @escaping ([T]?) -> Void,
        completion: VoidClosure? = nil
    ) where T: NSManagedObject {
        let request = T.fetchRequest()
        request.predicate = predicate
        
        self.backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            block(self.backgroundContext.get(with: request))
            self.saveBackgroundContext()
            completion?()
        }
    }
    
    public func delete<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        completion: VoidClosure? = nil
    ) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        self.backgroundContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                try self.backgroundContext.execute(deleteRequest)
                self.saveBackgroundContext()
                completion?()
            } catch {
                let nsError = error as NSError
                assertionFailure("Ошибка при удалении: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func delete<T>(with type: T.Type, predicate: NSPredicate?) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        self.backgroundContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                try self.backgroundContext.execute(deleteRequest)
                self.saveBackgroundContext()
            } catch {
                let nsError = error as NSError
                assertionFailure("Ошибка при удалении: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func delete<T>(managedObject: T) where T: NSManagedObject {
        self.backgroundContext.delete(managedObject)
        self.saveBackgroundContext()
    }
}

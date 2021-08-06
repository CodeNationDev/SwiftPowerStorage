//
import Foundation
import CoreData
import SwiftMagicHelpers

public let sharedSPSManager = SPSManager()

open class PersistentContainer: NSPersistentCloudKitContainer {}

open class SPSManager: NSObject {
    
    public lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let modelURL = Bundle.module.url(forResource:"CoreModel", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: modelURL!)
        let container = PersistentContainer(name:"CoreModel",managedObjectModel:model!)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Function for save ANY object.
    public func saveParameter<T: Codable>(forKey: String, object: T, completionHandler: (( SPSResult<T>)->())? = nil) {
        do {
            let encoded = try HelperManager.JSON.jsonEncode(object)
            if let _ = try self.removeParameter(forKey: forKey, type: type(of: object)) as? String {
                if(self.saveParamCoreData(forKey: forKey, value: encoded)) {
                    if let completion = completionHandler {
                        completion(SPSResult.success(value: try! HelperManager.JSON.jsonDecode(encoded, type: type(of: object)))) }
                } else {
                    if let completion = completionHandler { completion(SPSResult.failure) }
                }
            } else {
                if(self.saveParamCoreData(forKey: forKey, value: encoded)) {
                    if let completion = completionHandler { completion(SPSResult.success(value: try! HelperManager.JSON.jsonDecode(encoded, type: type(of: object)))) }
                } else {
                    if let completion = completionHandler { completion(SPSResult.failure) }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func loadParameter<T:Codable>(forKey: String, type: T.Type) throws -> T? {
        if let param = loadParamCoreData(forKey: forKey) {
            do {
                return try HelperManager.JSON.jsonDecode(param, type: type)
            } catch let error {
                throw SPSError(message: error.localizedDescription, errorType: SPSError.ErrorType.typeError)
            }
            
        }
        return nil
    }
    
    private func saveParamCoreData(forKey: String, value: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "UniversalEntity", in: self.persistentContainer.viewContext)!
        let shortcut = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        shortcut.setValue(forKey, forKey: "key")
        shortcut.setValue(value, forKey: "value")
        self.saveContext()
        return true
    }
    
    private func loadParamCoreData(forKey: String? = nil) -> String? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UniversalEntity")
        if let forkey = forKey {
            let predicate = NSPredicate(format: "key == %@", forkey)
            fetchRequest.predicate = predicate
        }
        do {
            if let param = try self.persistentContainer.viewContext.fetch(fetchRequest).first?.value(forKey: "value") as? String {
                return param
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func removeParameter<T:Codable>(forKey: String, type: T.Type) throws -> T? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UniversalEntity")
        let predicate = NSPredicate(format: "key == %@", forKey)
        fetchRequest.predicate = predicate
        do {
            let result = try self.persistentContainer.viewContext.fetch(fetchRequest)
            if let first = result.first {
                let aux = try loadParameter(forKey: forKey, type: type)
                self.persistentContainer.viewContext.delete(first)
                try self.persistentContainer.viewContext.save()
                return aux
            }
            
        } catch let error {
            throw SPSError(message: error.localizedDescription, errorType: SPSError.ErrorType.typeError)
        }
        return nil
    }
    
    public func destroyPersistenStore() -> Bool {
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UniversalEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try persistentContainer.viewContext.execute(deleteRequest)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
}

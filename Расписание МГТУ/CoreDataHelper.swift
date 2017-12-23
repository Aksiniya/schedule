import UIKit
import CoreData

class CoreDataHelper: NSObject {

    // MARK: - Singleton
    /*
     Singleton гарантирует наличие только одного экземпляра класса с глобальной точкой доступа. То есть, у класса всегда существует один и только один объект, независимо от того, кто, когда и откуда к нему обращается.
    */
    
    class var instance: CoreDataHelper {
        struct Singleton{
                static let instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    // MARK: - Core Data stack
    
    // координатор хранилища - посредник между хранилищем данных и контекстом(отвечает за хранение данных и их кэширование)
    let coordinator: NSPersistentStoreCoordinator
    // модель объекта - содержит все сущности, взаимосвязи и атрибуты("поля")
    let model: NSManagedObjectModel
    // контекст управляемого объекта
    let context: NSManagedObjectContext
    
    private override init() {
        
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        let fileManager = NSFileManager.defaultManager()
        
        //где будет лежать объект базы - ссылка на папку documents
        let docsURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
        
        // путь к папке документов -> создание по ссылке docsURL файла base.sqlite
        let storeURL = docsURL.URLByAppendingPathComponent("base.sqlite")
        
        // координатор на основе моделей
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            abort()
        }

        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = coordinator
        super.init()
    }
    
    // описание сущности(entity) по имени
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.context)!
    }
    
    func save(){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

import Foundation
import CoreData

class Settings: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataHelper.instance.entityForName("Settings"), insertIntoManagedObjectContext: CoreDataHelper.instance.context)
    }
}

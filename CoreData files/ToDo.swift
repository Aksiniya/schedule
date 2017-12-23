import Foundation
import CoreData


class ToDo: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataHelper.instance.entityForName("ToDo"), insertIntoManagedObjectContext: CoreDataHelper.instance.context)
    }
}

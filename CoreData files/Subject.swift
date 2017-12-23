import Foundation
import CoreData

@objc(Subject)
class Subject: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataHelper.instance.entityForName("Subject"), insertIntoManagedObjectContext: CoreDataHelper.instance.context)
    }
}

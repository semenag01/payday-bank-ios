// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BOUser.swift instead.

import Foundation
import CoreData

public enum BOUserAttributes: String {
    case identifier = "identifier"
}

open class _BOUser: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "BOUser"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<BOUser> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _BOUser.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var identifier: Int64 // Optional scalars not supported

    // MARK: - Relationships

}


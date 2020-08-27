// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BOAccount.swift instead.

import Foundation
import CoreData

public enum BOAccountAttributes: String {
    case active = "active"
    case customerId = "customerId"
    case dateCreated = "dateCreated"
    case iban = "iban"
    case identifier = "identifier"
    case type = "type"
}

open class _BOAccount: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "BOAccount"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<BOAccount> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _BOAccount.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var active: Bool // Optional scalars not supported

    @NSManaged open
    var customerId: Int64 // Optional scalars not supported

    @NSManaged open
    var dateCreated: Date?

    @NSManaged open
    var iban: String?

    @NSManaged open
    var identifier: Int64 // Optional scalars not supported

    @NSManaged open
    var type: String?

    // MARK: - Relationships

}


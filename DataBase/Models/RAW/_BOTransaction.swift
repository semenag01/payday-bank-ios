// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BOTransaction.swift instead.

import Foundation
import CoreData

public enum BOTransactionAttributes: String {
    case amount = "amount"
    case category = "category"
    case date = "date"
    case identifier = "identifier"
    case vendor = "vendor"
}

open class _BOTransaction: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "BOTransaction"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<BOTransaction> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _BOTransaction.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var amount: String?

    @NSManaged open
    var category: String?

    @NSManaged open
    var date: Date?

    @NSManaged open
    var identifier: Int64 // Optional scalars not supported

    @NSManaged open
    var vendor: String?

    // MARK: - Relationships

}


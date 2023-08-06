//
//  CatalinaDB+CoreDataProperties.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//
//

import Foundation
import CoreData


extension CatalinaDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatalinaDB> {
        return NSFetchRequest<CatalinaDB>(entityName: "CatalinaDB")
    }

    @NSManaged public var tratamiento: Double
    @NSManaged public var fecha: Date?
    @NSManaged public var pl_prod: Double
    @NSManaged public var pl_ley: Double
    @NSManaged public var pl_rec: Double
    @NSManaged public var id: UUID?

}

extension CatalinaDB : Identifiable {

}

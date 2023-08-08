//
//  CatalinaDB+CoreDataProperties.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 10/08/23.
//
//

import Foundation
import CoreData


extension CatalinaDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatalinaDB> {
        return NSFetchRequest<CatalinaDB>(entityName: "CatalinaDB")
    }

    @NSManaged public var fecha: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var pl_ley: Double
    @NSManaged public var pl_prod: Double
    @NSManaged public var pl_rec: Double
    @NSManaged public var tratamiento: Double
    @NSManaged public var zn_ley: Double
    @NSManaged public var zn_prod: Double
    @NSManaged public var zn_rec: Double
    @NSManaged public var pl_finos: Double
    @NSManaged public var zn_finos: Double
    @NSManaged public var ley_pb: Double
    @NSManaged public var headpb: Double
    @NSManaged public var ley_zn: Double
    @NSManaged public var headzn: Double

}

extension CatalinaDB : Identifiable {

}

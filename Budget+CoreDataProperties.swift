//
//  Budget+CoreDataProperties.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 10/08/23.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var budget_mes: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var pb_prodB: Double
    @NSManaged public var pb_leyB: Double
    @NSManaged public var pb_recB: Double
    @NSManaged public var tratamientoB: Double
    @NSManaged public var zn_leyB: Double
    @NSManaged public var zn_prodB: Double
    @NSManaged public var zn_recB: Double
    @NSManaged public var pb_leyyB: Double
    @NSManaged public var zn_leyyB: Double
    @NSManaged public var pb_finosB: Double
    @NSManaged public var zn_finosB: Double
    @NSManaged public var pb_headB: Double
    @NSManaged public var zn_headB: Double

}

extension Budget : Identifiable {

}

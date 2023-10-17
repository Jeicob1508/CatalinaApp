//
//  ObjectBudget.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 10/10/23.
//

import Foundation

class ObjectBudget: Identifiable, Decodable, Hashable{
    
    var id             : Int    = 0
    var tratamiento    : Double = 0.000
    var varLeyPB       : Double = 0.000
    var varLeyZN       : Double = 0.000
    
    // Plomo
    var PBProduccion   : Double = 0.000
    var PBCalidad      : Double = 0.000
    var PBRecuperacion : Double = 0.000
    
    // Zinc
    var ZNProduccion   : Double = 0.000
    var ZNCalidad      : Double = 0.000
    var ZNRecuperacion : Double = 0.000
    
    // Finos
    var PBFinos        : Double = 0.000
    var ZNFinos        : Double = 0.000
    
    // Head
    var PBHead         : Double = 0.000
    var ZNHead         : Double = 0.000
    
    var Mantenimiento  : Int = 0
    
    static func == (lhs: ObjectBudget, rhs: ObjectBudget) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Encodable{
    var toDictionary: [String: Any]?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}



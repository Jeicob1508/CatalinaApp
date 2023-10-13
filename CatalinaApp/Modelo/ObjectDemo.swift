//
//  ObjectDemo.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 12/10/23.
//

import Foundation

class ObjectDemo: Encodable, Decodable, Hashable{
    var id:     String = ""
    var value:  String = ""
    var nuM:    Double = 0.000
    var num2:   Int = 0
    
    static func == (lhs: ObjectDemo, rhs: ObjectDemo) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Encodable{
    var toDictionary2: [String: Any]?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}

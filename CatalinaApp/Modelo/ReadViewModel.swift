//
//  ReadViewModel.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 12/10/23.
//

import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

class ReadViewModel: ObservableObject {
    var ref = Database.database().reference()
    @Published var value: String? = nil
    
    @Published var objectBudget: ObjectBudget? = nil
    @Published var listObject_Budget = [ObjectBudget]()
    
    func findObject(objectIdToFind: Int) {
        ref.queryOrdered(byChild: "id").queryEqual(toValue: objectIdToFind).observeSingleEvent(of: .value) { (snapshot, _) in
            if let objectData = snapshot.value as? [String: Any] {
                do {
                    let object = try JSONSerialization.data(withJSONObject: objectData)
                    self.objectBudget = try JSONDecoder().decode(ObjectBudget.self, from: object)
                } catch {
                    print("No se puede convertir a ObjectBudget: \(error)")
                }
            }
        }
    }
    
    func observeListObjects(){
        ref.child("Budget").observe(.value){ parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            self.listObject_Budget = children.compactMap({ snapshot in
                return try? snapshot.data(as: ObjectBudget.self)
            })
        }
    }
    func observeListObjectsD(){
        ref.child("Daily").observe(.value){ parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            self.listObject_Budget = children.compactMap({ snapshot in
                return try? snapshot.data(as: ObjectBudget.self)
            })
        }
    }
}

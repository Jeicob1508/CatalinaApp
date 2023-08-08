//
//  ConfiguracionView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI
import CoreData

struct ConfiguracionView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    var body: some View {
        VStack{
            Text("Bienvenido")
            HStack{
                Spacer()
                Text("\(globalState.nombrePer) \(globalState.apellidoPer)")
                Spacer()
                Button(action: {
                    withAnimation {
                        globalState.configNA.toggle()
                    }
                }) {
                    Image(systemName: "pencil") // Imagen del lápiz en un círculo lleno
                        .foregroundColor(.blue) // Color del círculo
                }
            }
            if globalState.esAdmin {
                Toggle("Predeterminado a la fecha actual?", isOn: $globalState.tipoFecha)
                    .padding()
            }
            Toggle("Admin?", isOn: $globalState.esAdmin)
                .padding()
            Button(action: {
                deleteAllItems()
            }) {
                Text("Eliminar Todos")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: {
                globalState.configBudge.toggle()
            }) {
                Text("Budget")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func deleteAllItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CatalinaDB.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.execute(batchDeleteRequest)
            try moc.save()
        } catch {
            print("Error deleting items: \(error)")
        }
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Budget.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        do {
            try moc.execute(batchDeleteRequest2)
            try moc.save()
        } catch {
            print("Error deleting items: \(error)")
        }
    }
    
}

struct ConfiguracionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfiguracionView()
    }
}

//
//  ContentView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \CatalinaDB.fecha, ascending: true),
            NSSortDescriptor(keyPath: \CatalinaDB.tratamiento, ascending: true),],
        animation: .default)
    private var catalinaDB: FetchedResults<CatalinaDB>

    static var fechaFormato = {
        let formato = DateFormatter()
        formato.dateStyle = .full
        return formato
    }()
    
    var fecha = Date()
    
    @State private var mostrar: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            Text("Prueba de la DB")
            Spacer()
            List{
                ForEach(catalinaDB, id: \.id) { catalinaDB in
                    VStack(alignment: .leading){
                        Text(String(format: "%.3f", catalinaDB.pl_prod))
                            .foregroundColor(.primary)
                    }
                }
            }
            
            Button(action:{
                self.mostrar.toggle()
            }){
                Image(systemName: "plus")
            }
            .sheet(isPresented: self.$mostrar, content: {
                AgregarInformacion().environment(\.managedObjectContext, self.moc)
            })
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

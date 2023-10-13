//
//  ContentView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData

struct HistoricoView22: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \CatalinaDB.fecha, ascending: false),],
        animation: .default)
    private var catalinaDB: FetchedResults<CatalinaDB>
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Budget.budget_mes, ascending: false),],
        animation: .default)
    private var budget: FetchedResults<Budget>
    
    static var fechaFormato = {
        let formato = DateFormatter()
        formato.dateStyle = .full
        return formato
    }()
    
    var fecha = Date()
    @State private var mostrar: Bool = false
    @State private var mes: Int64 = 0
    
    var body: some View {
        VStack{
            Spacer().frame(height: 15)
            Text("Resumen Diario")
                .font(.title)
                .font(.system(size: 20))
            List{
                ForEach(catalinaDB, id: \.id) { catalinaDB in
                    VStack(alignment: .leading){
                        HStack{
                            Text("\(catalinaDB.fecha ?? self.fecha, formatter: Self.fechaFormato)")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)

                        }
                        HStack{
                            Text("Tratamiento: ")
                                .font(.system(size: 10))
                            Text(String(format: "%.3f", catalinaDB.tratamiento))
                                .font(.system(size: 10))
                                .padding(.bottom, 0.2)
                        }
                        HStack{
                            Button(action: {
                                // Accion de Like
                            }) {
                                Image(systemName: "hand.thumbsup")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18))
                            }
                            Spacer()
                            Button(action:{
                                if let fecha = catalinaDB.fecha {
                                    globalState.verMasVista.toggle()
                                    //globalState.fechaInfo = fecha
                                }
                            }){
                                Text("Ver más")
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func busquedaBudget(budgetAnio: Int, budgetMes: Int) -> Date? {
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.year = budgetAnio
        dateComponents.month = budgetMes
        dateComponents.day = 1
        
        print(dateComponents)
        return calendar.date(from: dateComponents)
    }
    
    func obtenerNombreMes(numeroMes: Int64) -> String? {
        let numeroMes2 = numeroMes / 10000
        
        let calendar = Calendar(identifier: .gregorian)
        guard (1...12).contains(numeroMes2) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        
        if let date = calendar.date(from: DateComponents(year: 2000, month: Int(numeroMes2))) {
            let nombreMes = dateFormatter.string(from: date)
            return nombreMes.capitalized
        }
        return nil
    }
    
    func obteneranio(fecha: Int64) -> String {
        let numeroano = String(fecha % 10000)
        
        return numeroano
    }
    
}

struct HistoricoView22_Previews: PreviewProvider {
    static var previews: some View {
        HistoricoView22().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

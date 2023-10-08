//
//  ContentView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData

struct HistoricoView: View {
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
            Text("Resumen Mensual")
                .font(.headline)
            
            List{
                ForEach(budget, id: \.id) { budget in
                    VStack(alignment: .leading){
                        HStack{
                            if let nombreMes = obtenerNombreMes(numeroMes: budget.budget_mes) {
                                let numeroanio = obteneranio(fecha: budget.budget_mes)
                                Text("\(nombreMes) del \(numeroanio)")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundColor(.primary)
                            } else {
                                Text("Mes inválido")
                                    .foregroundColor(.red)
                            }
                        }
                        HStack{
                            Button(action:{
                                globalState.BudgetMes = budget.budget_mes
                                
                                let budgetmes = (Int(globalState.BudgetMes) / 10000)
                                let budgetanio = (Int(globalState.BudgetMes) % 10000)
                                
                                print(globalState.BudgetMes)
                                print(budgetmes)
                                print(budgetanio)
                                
                                globalState.fechaInfo = busquedaBudget(budgetAnio: budgetanio, budgetMes: budgetmes) ?? Date()
                                print(globalState.fechaInfo)
                                globalState.verMasVista2.toggle()
                            }){
                                Text("Ver más")
                            }
                        }
                        
                    }
                    .padding(.vertical, 5)
                }
            }
            .background(.blue)
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

struct HistoricoView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

//
//  ContentView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData

struct VistaDiario: View {
    @StateObject var viewModel = ReadViewModel()
    @StateObject var viewModel2 = ReadViewModel()
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    
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
            
            Spacer()
            VStack{
                if !viewModel.listObject_Budget.isEmpty {
                    VStack{
                        List{
                            ForEach (viewModel.listObject_Budget, id: \.self){ object in
                                ForEach(viewModel2.listObject_Budget, id: \.self) { objectB in
                                    VStack(alignment: .leading){
                                        HStack{
                                            if let fecha = obtenerFecha(object.id){
                                                Text("\(fecha.0) de \(fecha.1) del \(fecha.2)")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        HStack{
                                            Text("Tratamiento: ")
                                                .font(.system(size: 10))
                                            Text(String(format: "%.3f", object.tratamiento))
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
                                                globalState.TuplaBudget = (objectB.id, objectB.tratamiento, objectB.varLeyPB,
                                                                           objectB.varLeyZN, objectB.PBProduccion, objectB.PBCalidad,
                                                                           objectB.PBRecuperacion, objectB.ZNProduccion, objectB.ZNCalidad,
                                                                           objectB.ZNRecuperacion, objectB.PBFinos, objectB.ZNFinos,
                                                                           objectB.PBHead, objectB.ZNHead)
                                                
                                                globalState.TuplaBudgetD = (object.id, object.tratamiento, object.varLeyPB,
                                                                            object.varLeyZN, object.PBProduccion, object.PBCalidad,
                                                                            object.PBRecuperacion, object.ZNProduccion, object.ZNCalidad,
                                                                            object.ZNRecuperacion, object.PBFinos, object.ZNFinos,
                                                                            object.PBHead, object.ZNHead)
                                                globalState.ToggleDiario.toggle()
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
                }
            }
            .onAppear {
                viewModel.observeListObjectsD()
                viewModel2.observeListObjects()
            }
        }
    }
    
    func obtenerFecha(_ entero: Int) -> (Int, Int, Int)? {
        let stringValue = String(entero)
        
        guard stringValue.count == 8 else {
            return nil
        }
        
        if let day = Int(stringValue.prefix(2)),
           let month = Int(stringValue.prefix(4).suffix(2)),
           let year = Int(stringValue.suffix(4)) {
            return (day, month, year)
        } else {
            return nil
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
        VistaDiario().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

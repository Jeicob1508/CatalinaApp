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
            Text("Reporte Diario")
                .font(.title)
                .font(.system(size: 20))
            
            Spacer()
            VStack{
                if !viewModel.listObject_BudgetD.isEmpty {
                    let sortedList = viewModel.listObject_BudgetD.sorted { (obj1, obj2) in
                        let date1 = convertirFecha(String(obj1.id))
                        let date2 = convertirFecha(String(obj2.id))
                        return date1 > date2
                    }
                    
                    VStack{
                        List{
                            ForEach (sortedList.prefix(Int(globalState.CantRegistros)), id: \.self){ object in
                                VStack(alignment: .leading){
                                    HStack{
                                        Spacer()
                                        if let fecha = obtenerFecha(object.id){
                                            let temp = obtenerNombreMes(numeroMes: Int64(fecha.1))
                                            Text("\(fecha.0) de \(temp ?? "Error") del 20\(fecha.2)")
                                                .font(.system(size: 16))
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                    }
                                    HStack{
                                        Spacer()
                                        if object.tratamiento != 0.0 {
                                            Text("Tratamiento: ")
                                                .font(.system(size: 12))
                                            Text(String(format: "%.3f", object.tratamiento))
                                                .font(.system(size: 12))
                                                //.padding(.bottom, 0.2)
                                        } else {
                                            Text("Día de mantenimiento")
                                                .font(.system(size: 12))
                                        }
                                        Spacer()
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
                                            globalState.fechaInfoD = object.id
                                            globalState.TuplaBudgetD = (object.id, object.tratamiento, object.varLeyPB,
                                                                        object.varLeyZN, object.PBProduccion, object.PBCalidad,
                                                                        object.PBRecuperacion, object.ZNProduccion, object.ZNCalidad,
                                                                        object.ZNRecuperacion, object.PBFinos, object.ZNFinos,
                                                                        object.PBHead, object.ZNHead, object.Mantenimiento)
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
                } else {
                    VStack{
                        List{
                            HStack{
                                LoadingView()
                                Spacer().frame(width: 5)
                                Text("Cargando Datos")
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.observeListObjectsD()
            }
        }
    }
    
    func convertirFecha(_ fecha: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        
        // Agregar un "0" delante de la fecha si tiene 7 dígitos
        var fechaFormateada = fecha
        if fecha.count == 7 {
            fechaFormateada = "0" + fecha
        }
        
        if let date = dateFormatter.date(from: fechaFormateada) {
            return date
        } else {
            return Date.distantPast // Una fecha muy antigua para manejar errores
        }
    }
    
    func obtenerFecha(_ entero: Int) -> (Int, Int, Int)? {
        let year = entero % 100
        let month = (entero / 10000) % 100
        let day = (entero / 1000000)

        if year > 0 && month >= 1 && month <= 12 && day >= 1 && day <= 31 {
            return (day, month, year)
        } else {
            return nil
        }
    }
    
    func obtenerNombreMes(numeroMes: Int64) -> String? {
        
        let calendar = Calendar(identifier: .gregorian)
        guard (1...12).contains(numeroMes) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        
        if let date = calendar.date(from: DateComponents(year: 2000, month: Int(numeroMes))) {
            let nombreMes = dateFormatter.string(from: date)
            return nombreMes.capitalized
        }
        return nil
    }
}

struct HistoricoView22_Previews: PreviewProvider {
    static var previews: some View {
        VistaDiario().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

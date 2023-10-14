//
//  ContentView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

struct VistaMes: View {
    @StateObject var viewModel = ReadViewModel()
    @Environment(\.colorScheme) var colorScheme
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
    @State private var vRMtratamientoB: Double = 0.000
    
    var body: some View {
        VStack{
            Spacer().frame(height: 15)
            Text("Resumen Mensual")
                .font(.title)
                .font(.system(size: 20))
            Spacer()
            VStack {
                if !viewModel.listObject_Budget.isEmpty {
                    VStack{
                        List{
                            ForEach(viewModel.listObject_Budget, id: \.self) { object in
                                VStack(alignment: .leading){
                                    HStack{
                                        if let nombreMes = obtenerNombreMes(numeroMes: Int64(object.id)) {
                                            let numeroanio = obteneranio(fecha: Int64(object.id))
                                            Text("\(nombreMes) del \(numeroanio)")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .foregroundColor(.primary)
                                                .font(.system(size: 16))
                                        }
                                    }
                                    HStack{
                                        Button(action:{
                                            let budgetmes = (Int(object.id) / 10000)
                                            let budgetanio = (Int(object.id) % 10000)
                                            globalState.fechaInfo = busquedaBudget(budgetAnio: budgetanio, budgetMes: budgetmes) ?? 0
                                            globalState.TuplaBudget = (object.id, object.tratamiento, object.varLeyPB,
                                                                       object.varLeyZN, object.PBProduccion, object.PBCalidad,
                                                                       object.PBRecuperacion, object.ZNProduccion, object.ZNCalidad,
                                                                       object.ZNRecuperacion, object.PBFinos, object.ZNFinos,
                                                                       object.PBHead, object.ZNHead)
                                            print("TuplaBudget copiado: \(globalState.TuplaBudget)")
                                            globalState.ToggleMes.toggle()
                                        }){
                                            Text("Ver más")
                                        }
                                    }
                                }
                                .padding(.vertical, 5)
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
                viewModel.observeListObjects()
                print("Hola")
            }
        }
    }
    
    func busquedaBudget(budgetAnio: Int, budgetMes: Int) -> Int? {
        let budgetAnioString = String(format: "%04d", budgetAnio)
        let budgetMesString = String(format: "%02d", budgetMes)
        let concatenatedString =  budgetMesString + budgetAnioString
        
        print("La fecha es: \(concatenatedString)")
        
        return Int(concatenatedString)
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

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .frame(width: 80, height: 80)
                .cornerRadius(15)
        }
    }
}

struct HistoricoView_Previews: PreviewProvider {
    static var previews: some View {
        VistaMes().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

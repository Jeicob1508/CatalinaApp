//
//  ConfigBudget.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 9/08/23.
//

import SwiftUI
import CoreData
import FirebaseDatabase
import UIKit

struct ConfigBudget: View {
    @State private var showAlert2 = false
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    @State private var fechaMes = Calendar.current.component(.month, from: Date()) - 1
    private let months = Calendar.current.monthSymbols
    
    private let database = Database.database().reference()
    
    @State private var txtfieldd: String = ""
    @State private var txtfielmm: String = ""
    @State private var txtfielaa: String = ""
    
    @State private var txtfieldL: String = ""
    @State private var txtfieldP: String = ""
    @State private var txtfieldR: String = ""
    
    @State private var txtfieldzL: String = ""
    @State private var txtfieldzP: String = ""
    @State private var txtfieldzR: String = ""
    
    @State private var txtfieldtra: String = ""
    
    @State private var txtfieldley_pb: String = ""
    @State private var txtfieldley_zn: String = ""
    @State private var resultado: String = ""
    
    @State private var varpl_ley: Double = 0.000
    @State private var varpl_prod: Double = 0.000
    @State private var varpl_rec: Double = 0.000
    
    @State private var varley_pb: Double = 0.000
    @State private var varley_zn: Double = 0.000
    
    @State private var varzn_ley: Double = 0.000
    @State private var varzn_prod: Double = 0.000
    @State private var varzn_rec: Double = 0.000
    
    @State private var pb_finos: Double = 0.000
    @State private var zn_finos: Double = 0.000
    
    @State private var head_pb: Double = 0.000
    @State private var head_zn: Double = 0.000
    
    @State private var vartra: Double = 0.000
    
    @State private var varfecha: Int64 = 0
    @State private var mesfecha: Int64 = 0
    @State private var aniofecha: Int64 = 0
    
    @State private var recordExists = false
    @State private var editarIP: UUID = UUID()
    
    @State private var registroExistente: Budget?
    
    @State private var inputText = "" // Valor de entrada como cadena
    @State private var formattedText = "0.000" // Valor formateado
    
    @State private var txtfieldanio = "\(Calendar.current.component(.year, from: Date()))"
    
    private func recordExistsForMonthAndYear(month: Int, year: Int) -> Bool {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        let predicate = NSPredicate(format: "budget_mes == %lld", Int64("\(month)\(year)") ?? 0)
        fetchRequest.predicate = predicate
        
        do {
            let records = try moc.fetch(fetchRequest)
            if let firstRecord = records.first {
                editarIP = firstRecord.id ?? UUID()
                registroExistente = firstRecord
            } else {
                editarIP = UUID()
                registroExistente = nil
            }
            return !records.isEmpty
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
            return false
        }
    }
    
    private func nuevaEntradaFB() {
        let object: [String: Any] = [
            "id"            : self.varfecha,
            
            "tratamiento"   : self.vartra,
            "varLeyPB"      : self.varley_pb,
            "varLeyZN"      : self.varley_zn,
            
            "PBProduccion"  : self.varpl_prod,
            "PBCalidad"     : self.varpl_ley,
            "PBRecuperacion": self.varpl_rec,
            
            "ZNProduccion"  : self.varzn_prod,
            "ZNCalidad"     : self.varzn_ley,
            "ZNRecuperacion": self.varzn_rec,
            
            "PBFinos"       : self.pb_finos,
            "ZNFinos"       : self.zn_finos,
            
            "PBHead"        : self.head_pb,
            "ZNHead"        : self.head_zn
            
        ]
        database.child("Budget").child("Budget-\(self.varfecha)").setValue(object)
    }
    
    var body: some View {
        ScrollView{
            VStack() {
                Spacer().frame(height: 20)
                
                VStack(spacing: 10) {
                    Text("Tratamiento")
                        .font(.title)
                        .bold()
                    
                    creartxtField(texto1: "Valor:", texto2: "Tratamiento", variable: $txtfieldtra)
                    creartxtField(texto1: "Ley de Plomo: ", texto2: "Ley de Plomo", variable: $txtfieldley_pb)
                    creartxtField(texto1: "Ley de Zinc:", texto2: "Ley de Zinc:", variable: $txtfieldley_zn)
                }
                VStack(spacing: 10) {
                    Text("Plomo")
                        .font(.title)
                        .bold()
                    creartxtField(texto1: "Producción:", texto2: "Ingresa un valor", variable: $txtfieldP)
                    creartxtField(texto1: "Calidad:", texto2: "Ingresa un valor", variable: $txtfieldL)
                        .onChange(of: txtfieldL) { newValue in
                            calcularPlomoFinos()
                        }
                    creartxtField(texto1: "Recuperación:", texto2: "Ingresa un valor", variable: $txtfieldR)
                }
                VStack(spacing: 10) {
                    Text("Zinc")
                        .font(.title)
                        .bold()
                    
                    creartxtField(texto1: "Producción:", texto2: "Ingresa un valor", variable: $txtfieldzP)
                    creartxtField(texto1: "Calidad:", texto2: "Ingresa un valor", variable: $txtfieldzL)
                        .onChange(of: txtfieldzL) { newValue in
                            calcularZincFinos()
                        }
                    creartxtField(texto1: "Recuperación:", texto2: "Ingresa un valor", variable: $txtfieldzR)
                }
                HStack {
                    Spacer()
                    Text("Fecha:")
                        .font(.headline)
                    Spacer()
                    Picker("Mes: ", selection: $fechaMes) {
                        ForEach(1..<13, id: \.self) { month in
                            Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                        }
                    }
                    .onChange(of: fechaMes) { newValue in
                        let selectedMonth = newValue
                        let selectedYear = Int(txtfieldanio) ?? 0
                        recordExists = recordExistsForMonthAndYear(month: selectedMonth, year: selectedYear)
                    }
                    .onAppear {
                        let selectedMonth = fechaMes
                        let selectedYear = Int(txtfieldanio) ?? 0
                        recordExists = recordExistsForMonthAndYear(month: selectedMonth, year: selectedYear)
                    }
                    .pickerStyle(DefaultPickerStyle())
                    
                    TextField("Año", text: $txtfieldanio)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 75)
                    
                    Spacer()
                }

                
                VStack{
                    if recordExists{
                        HStack{
                            Text("Ya se encuentra un registro en esa fecha, estas editando el registro ya existente.")
                                .foregroundColor(.red)
                                .font(.headline)
                            Button(action: {
                                editarDatos()
                            }) {
                                HStack {
                                    Image(systemName: "eye")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Ver")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .frame(width: 100, height: 17)
                                .font(.system(size: 15, weight: .semibold))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                globalState.configBudge.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("Cerrar")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 120, height: 20)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            varpl_prod = Double(txtfieldP) ?? 0.000
                            varpl_ley = Double(txtfieldL) ?? 0.000
                            varpl_rec = Double(txtfieldR) ?? 0.000
                            
                            varzn_prod = Double(txtfieldzP) ?? 0.000
                            varzn_ley = Double(txtfieldzL) ?? 0.000
                            varzn_rec = Double(txtfieldzR) ?? 0.000
                            
                            vartra = Double(txtfieldtra) ?? 0.000
                            
                            varley_pb = Double(txtfieldley_pb) ?? 0.000
                            varley_zn = Double(txtfieldley_zn) ?? 0.000
                            
                            calcular()
                            calcularmes()
                            
                            nuevaEntradaFB()
                            globalState.configBudge.toggle()
                            
                        }){
                            HStack {
                                Image(systemName: recordExists ? "pencil" : "plus")
                                    .foregroundColor(.white)
                                Spacer()
                                Text(recordExists ? "Editar" : "Agregar")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 120, height: 20)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(recordExists ? Color.yellow: Color.green)
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .multilineTextAlignment(.center)
    }
    
    func creartxtField(texto1: String, texto2: String, variable: Binding<String>) -> some View {
        return HStack {
            Spacer().frame(width: 15)
            Text(texto1)
                .font(.title3)
                .frame(width: 140, alignment: .leading)
            Spacer()
            TextField(texto2, text: variable)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            Spacer().frame(width: 15)
        }
    }
    
    func calcular(){
        head_pb = (vartra * varley_pb / 100)
        head_zn = (vartra * varley_zn / 100)
    }
    func calcularPlomoFinos() {
        if let pValue = Double(txtfieldP), let lValue = Double(txtfieldL) {
            pb_finos = pValue * lValue / 100
        }
    }
    func calcularZincFinos() {
        if let znValue = Double(txtfieldzP), let zn2Value = Double(txtfieldzL) {
            zn_finos = znValue * zn2Value / 100
        }
    }
    func calcularmes(){
        resultado = "\(fechaMes)\(txtfieldanio)"
        varfecha = Int64(resultado) ?? 0
    }
    func editarDatos(){
        if let registro = registroExistente {
            txtfieldP = "\(registro.pb_prodB)"
            txtfieldL = "\(registro.pb_leyB)"
            txtfieldR = "\(registro.pb_recB)"

            txtfieldzP = "\(registro.zn_prodB)"
            txtfieldzL = "\(registro.zn_leyB)"
            txtfieldzR = "\(registro.zn_recB)"

            txtfieldtra = "\(registro.tratamientoB)"
            txtfieldley_pb = "\(registro.pb_leyyB)"
            txtfieldley_zn = "\(registro.zn_leyyB)"
        }
    }
    func formatInputText() {
        // Convertir la cadena de entrada a un número decimal
        if let inputValue = Double(inputText) {
            // Formatear el número con tres decimales
            let formattedValue = String(format: "%.3f", inputValue)
            formattedText = formattedValue
            inputText = formattedValue // Reemplazar la entrada con el valor formateado
        } else {
            // Manejar la entrada no válida aquí
            // Por ejemplo, puedes mostrar un mensaje de error
            print("Entrada no válida")
        }
    }
}


struct ConfigBudget_Previews: PreviewProvider {
    static var previews: some View {
        ConfigBudget()
    }
}

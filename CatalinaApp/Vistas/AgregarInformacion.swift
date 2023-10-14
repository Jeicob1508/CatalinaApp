//
//  AgregarInformacion.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData
import FirebaseDatabase
import UIKit

struct AgregarInformacion: View {
    private let database = Database.database().reference()
    @EnvironmentObject var globalState: GlobalState
    @Binding var isShowingPopUp: Bool
    @Environment(\.managedObjectContext) private var moc
    @State private var fechaMes = Calendar.current.component(.month, from: Date()) - 1
    private let months = Calendar.current.monthSymbols
    
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
    
    @State private var hasExistingData = false
    
    @State private var vartra: Double = 0.000
    @State private var editarIP: UUID = UUID()
    @State private var varfecha: Int64 = 0
    
    @State private var registroExistente: CatalinaDB?
    
    @State private var fechaSeleccionada: Date = Date()
    
    private func buscarFechaExistente(day: Int, month: Int, year: Int) -> Bool {
        let fetchRequest: NSFetchRequest<CatalinaDB> = CatalinaDB.fetchRequest()
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = NSPredicate(format: "fecha >= %@ AND fecha < %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = predicate

        do {
            let records = try moc.fetch(fetchRequest)
            
            if let record = records.first {
                editarIP = record.id ?? UUID() // Use UUID.nil to represent absence of value
                registroExistente = record
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
        database.child("Daily").child("Daily-\(self.varfecha)").setValue(object)
    }

    var body: some View {
        ScrollView{
            VStack() {
                Spacer().frame(height: 50)
                
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
                    
                    DatePicker("", selection: $fechaSeleccionada, in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .frame(maxWidth: 220)
                        .padding()
                        .onAppear {
                            if globalState.tipoFecha {
                                fechaSeleccionada = Date()
                                
                            } else {
                                fechaSeleccionada = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                            }
                            let selectedDay = Calendar.current.component(.day, from: fechaSeleccionada)
                            let selectedMonth = Calendar.current.component(.month, from: fechaSeleccionada)
                            let selectedYear = Calendar.current.component(.year, from: fechaSeleccionada)
                            
                            varfecha = Int64((selectedDay * 1000000) + (selectedMonth * 10000) + selectedYear)
                        }
                        .onChange(of: fechaSeleccionada) { newValue in
                            
                            let selectedDay = Calendar.current.component(.day, from: newValue)
                            let selectedMonth = Calendar.current.component(.month, from: newValue)
                            let selectedYear = Calendar.current.component(.year, from: newValue)
                            
                            varfecha = Int64((selectedDay * 1000000) + (selectedMonth * 10000) + selectedYear)
                            
                            hasExistingData = buscarFechaExistente(day: selectedDay, month: selectedMonth, year: selectedYear)
                        }
                }
                
                if hasExistingData{
                    HStack{
                        Text("Ya se encuentra un registro en esa fecha, estas editando el registro ya existente.")
                            .foregroundColor(.red) // You can choose your desired color
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
                VStack{

                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isShowingPopUp = false
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
                            
                            if hasExistingData{
                                nuevaEntradaFB()
                            } else{
                                nuevaEntradaFB()
                            }
                            
                            isShowingPopUp = false
                        }) {
                            HStack {
                                Image(systemName: hasExistingData ? "pencil" : "plus")
                                    .foregroundColor(.white)
                                Spacer()
                                Text(hasExistingData ? "Editar" : "Agregar")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 120, height: 20)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(hasExistingData ? Color.yellow: Color.green)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
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
    func editarDatos(){
        if let registro = registroExistente {
            txtfieldP = "\(registro.pl_prod)"
            txtfieldL = "\(registro.pl_ley)"
            txtfieldR = "\(registro.pl_rec)"
            
            txtfieldzP = "\(registro.zn_prod)"
            txtfieldzL = "\(registro.zn_ley)"
            txtfieldzR = "\(registro.zn_rec)"
            
            txtfieldtra = "\(registro.tratamiento)"
            txtfieldley_pb = "\(registro.pl_ley)"
            txtfieldley_zn = "\(registro.zn_ley)"
        }
    }
}


struct AgregarInformacion_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var isShowingPopUp = false
        let globalState = GlobalState()
        
        AgregarInformacion(isShowingPopUp: $isShowingPopUp)
            .environmentObject(globalState)
    }
}

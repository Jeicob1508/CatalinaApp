//
//  ConfigBudget.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 9/08/23.
//

import SwiftUI
import CoreData

struct ConfigBudget: View {
    @EnvironmentObject var globalState: GlobalState
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
    
    private func agregarInformacion() {
        
        let agregar = Budget(context: self.moc)
        
        agregar.pb_prodB = self.varpl_prod
        agregar.pb_leyB = self.varpl_ley
        agregar.pb_recB = self.varpl_rec
        
        agregar.zn_prodB = self.varzn_prod
        agregar.zn_leyB = self.varzn_ley
        agregar.zn_recB = self.varzn_rec
        
        agregar.pb_finosB = self.pb_finos
        agregar.zn_finosB = self.zn_finos
        
        agregar.tratamientoB = self.vartra
        
        agregar.pb_leyyB = self.varley_pb
        agregar.zn_leyyB = self.varley_zn
        
        agregar.pb_headB = self.head_pb
        agregar.zn_headB = self.head_zn
        
        agregar.budget_mes = self.varfecha
        
        agregar.id = UUID()
        
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            print("Error al guardar la transacción: \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func editarInformacion() {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", editarIP as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let records = try moc.fetch(fetchRequest)
            
            if let record = records.first {
                record.pb_prodB = self.varpl_prod
                record.pb_leyB = self.varpl_ley
                record.pb_recB = self.varpl_rec
                
                record.zn_prodB = self.varzn_prod
                record.zn_leyB = self.varzn_ley
                record.zn_recB = self.varzn_rec
                
                record.pb_finosB = self.pb_finos
                record.zn_finosB = self.zn_finos
                
                record.tratamientoB = self.vartra
                
                record.pb_leyyB = self.varley_pb
                record.zn_leyyB = self.varley_zn
                
                record.pb_headB = self.head_pb
                record.zn_headB = self.head_zn
                
                record.budget_mes = self.varfecha
                
                
                // Guarda los cambios en el contexto
                do {
                    try moc.save()
                    print("Registro editado exitosamente.")
                } catch {
                    print("Error saving record: \(error.localizedDescription)")
                }
            } else {
                print("No se encontró el registro con la ID especificada.")
            }
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ScrollView{
            VStack() {
                Spacer().frame(height: 20)
                
                VStack(spacing: 10) {
                    Text("Plomo")
                        .font(.title)
                        .bold()
                    
                    TextField("Producción", text: $txtfieldP)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Calidad", text: $txtfieldL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: txtfieldL) { newValue in
                            calcularPlomoFinos()
                        }
                    TextField("Recuperación", text: $txtfieldR)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(width: 200)
                
                
                VStack(spacing: 10) {
                    Text("Zinc")
                        .font(.title)
                        .bold()
                    
                    TextField("Producción", text: $txtfieldzP)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Calidad", text: $txtfieldzL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: txtfieldzL) { newValue in
                            calcularZincFinos()
                        }
                    TextField("Recuperación", text: $txtfieldzR)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(width: 200)
                
                VStack(spacing: 10) {
                    Text("Tratamiento")
                        .font(.title)
                        .bold()
                    
                    TextField("Valor", text: $txtfieldtra)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Ley de Plomo", text: $txtfieldley_pb)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Ley de Zinc", text: $txtfieldley_zn)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                .frame(width: 200)
                /*
                 VStack {
                 Text(String(format: "Plomo finos: %.3f", pb_finos))
                 Text(String(format: "Zinc finos: %.3f", zn_finos))
                 }
                 */
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
                    HStack{
                        Text("Ya se encuentra un registro en esa fecha, estas editando el registro ya existente.")
                            .foregroundColor(.red) // You can choose your desired color
                            .font(.headline)
                            .opacity( recordExists ? 1 : 0)
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
                            .opacity( recordExists ? 1 : 0)
                        }
                    }
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            globalState.configBudge.toggle()
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
                            
                            calcularmes()
                            if recordExists{
                                editarInformacion()
                            } else{
                                agregarInformacion()
                            }
                            calcular()
                            globalState.configBudge.toggle()
                            
                        }) {
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
}


struct ConfigBudget_Previews: PreviewProvider {
    static var previews: some View {
        ConfigBudget()
    }
}

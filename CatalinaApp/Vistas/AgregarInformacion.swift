//
//  AgregarInformacion.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI
import CoreData

struct AgregarInformacion: View {
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
    
    private func agregarInformacion() {

        let agregar = CatalinaDB(context: self.moc)
        
        agregar.pl_prod = self.varpl_prod
        agregar.pl_ley = self.varpl_ley
        agregar.pl_rec = self.varpl_rec
        
        agregar.zn_prod = self.varzn_prod
        agregar.zn_ley = self.varzn_ley
        agregar.zn_rec = self.varzn_rec
        
        agregar.pl_finos = self.pb_finos
        agregar.zn_finos = self.zn_finos
        
        agregar.tratamiento = self.vartra
        
        agregar.ley_pb = self.varley_pb
        agregar.ley_zn = self.varley_zn
        
        agregar.headpb = self.head_pb
        agregar.headzn = self.head_zn
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: fechaSeleccionada)
        agregar.fecha = calendar.date(from: components)!
        
        agregar.id = UUID()
        
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            print("Error al guardar la transacción: \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func editarInformacion() {
        let fetchRequest: NSFetchRequest<CatalinaDB> = CatalinaDB.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", editarIP as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let records = try moc.fetch(fetchRequest)
            
            if let record = records.first {
                record.pl_prod = self.varpl_prod
                record.pl_ley = self.varpl_ley
                record.pl_rec = self.varpl_rec
                
                record.zn_prod = self.varzn_prod
                record.zn_ley = self.varzn_ley
                record.zn_rec = self.varzn_rec
                
                record.pl_finos = self.pb_finos
                record.zn_finos = self.zn_finos
                
                record.tratamiento = self.vartra
                
                record.ley_pb = self.varley_pb
                record.ley_zn = self.varley_zn
                
                record.headpb = self.head_pb
                record.headzn = self.head_zn
                
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: fechaSeleccionada)
                record.fecha = calendar.date(from: components)!
                
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
                        }
                        .onChange(of: fechaSeleccionada) { newValue in
                            
                            let selectedDay = Calendar.current.component(.day, from: newValue)
                            let selectedMonth = Calendar.current.component(.month, from: newValue)
                            let selectedYear = Calendar.current.component(.year, from: newValue)
                            
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
                                editarInformacion()
                            } else{
                                agregarInformacion()
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

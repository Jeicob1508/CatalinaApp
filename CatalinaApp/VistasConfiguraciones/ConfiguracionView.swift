//
//  ConfiguracionView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI
import CoreData

struct ConfiguracionView: View {
    
    @State private var showAlert = false
    @State private var showAlert2 = false
    @State private var selectedDate = Date()
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        Form {
            Section(header: Text("Usuario")) {
                HStack{
                    Image(systemName: "person")
                        .font(.system(size: 50))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .background(Circle().foregroundColor(.white)) // Círculo de fondo blanco

                    VStack{
                        Spacer()
                        Text("\(globalState.nombrePer) \(globalState.apellidoPer)")
                            .font(.title2)
                        Spacer()
                    }
                }
            }

            if globalState.esAdmin {
                Section(header: Text("Opciones de Administrador")) {
                    Toggle("Fecha Actual", isOn: $globalState.tipoFecha)
                }
                
                Section(header: Text("Configuración Administrador")) {
                    
                    BotonIcono(color: Color.pastelRed, imageName: "xmark.bin", title: "Eliminar todos los registros") {
                        withAnimation {
                            self.showAlert2 = true
                        }
                    }
                    .alert(isPresented: $showAlert2) {
                        Alert(
                            title: Text("¿Estás seguro?"),
                            message: Text("Esta acción eliminará todos los registros."),
                            primaryButton: .destructive(Text("Sí")) {
                                deleteAllItems()
                            },
                            secondaryButton: .cancel(Text("Cancelar"))
                        )
                    }

                    HStack{
                        BotonIcono(color: Color.pastelRed, imageName: "x.circle", title: "") {
                            withAnimation {
                                self.showAlert = true
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Eliminar registro"),
                                message: Text("Vas a eliminar el registro del \(formattedDate)"),
                                primaryButton: .destructive(Text("Eliminar")) {
                                    deleteItem(withDate: selectedDate)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        DatePicker("Eliminar un registro", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                    }
                    
                    BotonIcono(color: Color.pastelRed, imageName: "calendar.badge.plus", title: "Agregar / Editar Budget") {
                        withAnimation {
                            globalState.configBudge.toggle()
                        }
                    }
                }
            }
            
            Section(header: Text("Perfil")) {
                BotonIcono(color: Color.pastelCyan, imageName: "person.fill", title: "Nombre") {
                    withAnimation {
                        globalState.configNA.toggle()
                    }
                }
                BotonIcono(color: Color.pastelCyan, imageName: "photo", title: "Foto de Perfil") {
                    // Acción para "Contraseña"
                }
            }
            
            Section(header: Text("Seguridad")) {
                BotonIcono(color: Color.pastelBlue, imageName: "key", title: "Contraseña") {
                    // Acción para "Contraseña"
                }
            }
            
            Section(header: Text("Otras Opciones")) {
                BotonIcono(color: Color.pastelGreen, imageName: "questionmark", title: "Manual") {
                    // Acción para "Manual"
                }
                
                BotonIcono(color: Color.pastelGreen, imageName: "questionmark", title: "Cantidad de Registros") {
                    
                }
                
            }
            
            Section(header: Text("Opciones Generales")) {
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.pastelLavender) // Color de fondo similar al de la app de configuración

                        Image(systemName: "person")
                            .foregroundColor(.black) // Color del icono
                    }
                    
                    Toggle("Admin", isOn: $globalState.esAdmin)
                    Spacer()
                }
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.pastelLavender) // Color de fondo similar al de la app de configuración

                        Image(systemName: "moon.fill")
                            .foregroundColor(.black) // Color del icono
                    }
                    
                    Toggle("Modo Oscuro", isOn: $globalState.modoOscuro)
                    Spacer()
                }
            }
            
            BotonIcono(color: Color.botonCerrar, imageName: "person.slash", title: "Cerrar Sesión" ){
                // Accion
            }
        }
        .navigationBarTitle("Configuración", displayMode: .inline)
    }
    
    func BotonIcono(color: Color, imageName: String, title: String, action: @escaping () -> Void) -> some View {
        return Button(action: action) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 35, height: 35)
                        .foregroundColor(color)

                    Image(systemName: imageName)
                        .foregroundColor(.black)
                }
                
                if title != ""{
                    
                    Text(title)
                        .lineLimit(1)
                        .foregroundColor(Color.primary)
                    Spacer()
                    
                }
            }
        }
    }
    
    func deleteAllItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CatalinaDB.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.execute(batchDeleteRequest)
            try moc.save()
        } catch {
            print("Error deleting items: \(error)")
        }
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Budget.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        do {
            try moc.execute(batchDeleteRequest2)
            try moc.save()
        } catch {
            print("Error deleting items: \(error)")
        }
    }
    
    func deleteItem(withDate date: Date) {
        let calendar = Calendar.current
        let truncatedDate = calendar.startOfDay(for: date) // Esto eliminará la hora y los minutos
        
        let fetchRequest: NSFetchRequest<CatalinaDB> = CatalinaDB.fetchRequest()
        let predicate = NSPredicate(format: "fecha >= %@ AND fecha < %@", truncatedDate as NSDate, calendar.date(byAdding: .day, value: 1, to: truncatedDate)! as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let itemsToDelete = try moc.fetch(fetchRequest)
            for item in itemsToDelete {
                moc.delete(item)
            }
            try moc.save()
            print("Elementos eliminados con éxito")
        } catch {
            print("Error al eliminar los elementos: \(error)")
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES") // Establece la localización en español
        formatter.dateFormat = "d 'de' MMMM 'del' yyyy"
        return formatter.string(from: selectedDate)
    }
}

extension Color {
    static let pastelBlue = Color(red: 0.6, green: 0.7, blue: 0.9)
    static let pastelGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
    static let pastelPink = Color(red: 0.9, green: 0.7, blue: 0.8)
    static let pastelRed = Color(red: 0.9, green: 0.7, blue: 0.7)
    static let pastelCyan = Color(red: 0.7, green: 0.9, blue: 0.9)
    static let pastelPurple = Color(red: 0.8, green: 0.7, blue: 0.9)
    static let pastelYellow = Color(red: 0.9, green: 0.9, blue: 0.7)
    static let pastelOrange = Color(red: 0.9, green: 0.7, blue: 0.6)
    static let pastelLavender = Color(red: 0.7, green: 0.8, blue: 0.9)
    static let botonCerrar = Color(red: 1.0, green: 0.2, blue: 0.2)
}

struct ConfiguracionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfiguracionView()
    }
}

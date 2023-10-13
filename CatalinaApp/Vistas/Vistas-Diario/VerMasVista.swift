//
//  VerMasVista.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//
/*
import SwiftUI
import CoreData

struct VerMasVista: View {
    /*
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var globalState: GlobalState
    @State private var fechaSeleccionada: Date = Date()
    @State private var vRMpl_ley: Double = 0.000
    @State private var vRMpl_prod: Double = 0.000
    @State private var vRMpl_rec: Double = 0.000
    @State private var vRMpl_finos: Double = 0.000
    
    @State private var vRMzn_ley: Double = 0.000
    @State private var vRMzn_prod: Double = 0.000
    @State private var vRMzn_rec: Double = 0.000
    @State private var vRMzn_finos: Double = 0.000
    
    @State private var vRMtratamiento: Double = 0.000
    
    @State private var vRMpl_leyB: Double = 0.000
    @State private var vRMpl_prodB: Double = 0.000
    @State private var vRMpl_recB: Double = 0.000
    @State private var vRMpl_finosB: Double = 0.000
    
    @State private var vRMzn_leyB: Double = 0.000
    @State private var vRMzn_prodB: Double = 0.000
    @State private var vRMzn_recB: Double = 0.000
    @State private var vRMzn_finosB: Double = 0.000
    
    @State private var vRMtratamientoB: Double = 0.000
    
    @Environment(\.managedObjectContext) private var moc
    
    let coloresFondo: [Color] = [
        Color(red: 206/255, green: 226/255, blue: 227/255), // Azul claro pastel
        Color(red: 241/255, green: 241/255, blue: 241/255), // Lila pastel
        Color(red: 247/255, green: 229/255, blue: 200/255), // Amarillo pastel
        Color(red: 243/255, green: 195/255, blue: 195/255), // Color Budget
        Color(red: 250/255, green: 214/255, blue: 214/255), // Rojo pastel
    ]
    
    static var fechaFormato: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .long
        formato.locale = Locale(identifier: "es")
        return formato
    }()
    
    var objetosFiltrados: [CatalinaDB] {
        let fetchRequest: NSFetchRequest<CatalinaDB> = CatalinaDB.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CatalinaDB.fecha, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "fecha == %@", globalState.fechaInfo as NSDate)
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    var objetosFiltrados2: [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Budget.budget_mes, ascending: false)]
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: globalState.fechaInfo)
        
        if let firstDateOfMonth = calendar.date(from: components) {
            let monthYearFormatter = DateFormatter()
            monthYearFormatter.dateFormat = "MMyyyy"
            let formattedMonthYear = monthYearFormatter.string(from: firstDateOfMonth)
            
            fetchRequest.predicate = NSPredicate(format: "budget_mes == %@", formattedMonthYear)
            
            do {
                return try moc.fetch(fetchRequest)
            } catch {
                return []
            }
        } else {
            return []
        }
    }
    */
    var body: some View {
    }
      /*
        ScrollView (showsIndicators: false) {
            Spacer().frame(height: 30)
            VStack {
                ForEach(objetosFiltrados, id: \.self) { objeto in
                    VStack(alignment: .leading) {
                        Text("Fecha: \(objeto.fecha ?? Date(), formatter: Self.fechaFormato)")
                            .font(.title)
                        ForEach(objetosFiltrados2, id: \.self) { objeto2 in
                            VStack(alignment: .leading) {
                            }
                            .onAppear{
                                
                                vRMpl_leyB = objeto2.pb_leyB
                                vRMpl_recB = objeto2.pb_recB
                                vRMpl_prodB = objeto2.pb_prodB
                                vRMpl_finosB = objeto2.pb_finosB
                                
                                vRMzn_leyB = objeto2.zn_leyB
                                vRMzn_recB = objeto2.zn_recB
                                vRMzn_prodB = objeto2.zn_prodB
                                vRMzn_finosB = objeto2.zn_finosB
                                
                                vRMtratamientoB = objeto2.tratamientoB
                                division(valor: objeto2.budget_mes)
                            }
                        }
                        .onAppear {
                            vRMpl_ley = objeto.pl_ley
                            vRMpl_rec = objeto.pl_rec
                            vRMpl_prod = objeto.pl_prod
                            vRMpl_finos = objeto.pl_finos
                            
                            vRMzn_ley = objeto.zn_ley
                            vRMzn_rec = objeto.zn_rec
                            vRMzn_prod = objeto.zn_prod
                            vRMzn_finos = objeto.zn_finos
                            
                            vRMtratamiento = objeto.tratamiento
                        }
                    }
                    Spacer().frame(height: 20)
                    
                    VStack{
                        crearGrafico(valor0: "(TMS)",valor1: "Tratamiento", valor2: CGFloat(vRMtratamiento), valor: CGFloat(vRMtratamientoB), valor3: 250, valor4: coloresFondo[4])
                            .transition(.move(edge: .top))
                        Spacer().frame(height: 20)
                        
                        Rectangle()
                            .frame(height: 5)
                            .frame(maxWidth: .infinity)
                            .background(colorScheme == .light ? Color.black : Color.white)
                        
                        Text("Plomo")
                            .font(.title2)
                        HStack{
                            crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor2: CGFloat(vRMpl_prod), valor: CGFloat(vRMpl_prodB), valor3: 125, valor4: coloresFondo[1])
                            crearGrafico(valor0: "(%Pb)",valor1: "Calidad", valor2: CGFloat(vRMpl_ley), valor: CGFloat(vRMpl_leyB), valor3: 125, valor4: coloresFondo[1])
                        }
                        HStack{
                            crearGrafico(valor0: "(%Pb)",valor1: "Recuperación", valor2: CGFloat(vRMpl_rec), valor: CGFloat(vRMpl_recB), valor3: 125, valor4: coloresFondo[1])
                            crearGrafico(valor0: "(TMS)",valor1: "Finos", valor2: CGFloat(vRMpl_finos), valor: CGFloat(vRMpl_finosB), valor3: 125, valor4: coloresFondo[1])
                        }
                        Spacer().frame(height: 20)
                        
                        
                        Rectangle()
                            .frame(height: 5)
                            .frame(maxWidth: .infinity)
                            .background(colorScheme == .light ? Color.black : Color.white)
                        
                        Text("Zinc")
                            .font(.title2)
                        HStack{
                            crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor2: CGFloat(vRMzn_prod), valor: CGFloat(vRMzn_prodB), valor3: 125, valor4: coloresFondo[2])
                            crearGrafico(valor0: "(%Zn)",valor1: "Calidad", valor2: CGFloat(vRMzn_ley), valor: CGFloat(vRMzn_leyB), valor3: 125, valor4: coloresFondo[2])
                        }
                        HStack{
                            crearGrafico(valor0: "(%Zn)",valor1: "Recuperación", valor2: CGFloat(vRMzn_rec), valor: CGFloat(vRMzn_recB), valor3: 125, valor4: coloresFondo[2])
                            crearGrafico(valor0: "(TMS)",valor1: "Finos", valor2: CGFloat(vRMzn_finos), valor: CGFloat(vRMzn_finosB), valor3: 125, valor4: coloresFondo[2])
                        }
                        Button(action: {
                            globalState.verMasVista = false
                        }) {
                            Text("Cerrar")
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func division(valor: Int64){
        
        var division = 0.000
        
        if valor == 2{
            division = 28
        } else{
            division = 30
        }
        
        vRMtratamientoB = vRMtratamientoB / division
        vRMpl_prodB = vRMpl_prodB / division
        vRMpl_finosB = vRMpl_finosB / division
        
        vRMzn_prodB = vRMzn_prodB / division
        vRMzn_finosB = vRMzn_finosB / division
        
    }
    
    func crearGrafico(valor0: String, valor1: String, valor2: CGFloat, valor: CGFloat, valor3: CGFloat, valor4: Color) -> some View {
        
        let alturas = calcularDibujo(valor: valor, valor2: valor2)
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                VStack{
                    Text(valor1)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .bold()
                        .frame(width: 300)
                    
                    Text(valor0)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .bold()
                        .frame(width: 300)
                }
                Spacer()
            }
            .frame(width: valor3)
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                VStack {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .foregroundColor(.green)
                            .frame(width: 20, height: max(10, alturas.0))
                            .cornerRadius(6)
                            .animation(.easeInOut(duration: 0.8), value: alturas.0)
                    }
                    Text(String(format: "%.3f", Double(valor)))
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .frame(width: 70)
                }
                .frame(width: 60)
                VStack {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 20, height: alturas.1)
                            .cornerRadius(6)
                            .animation(.easeInOut(duration: 0.8), value: alturas.1)
                    }
                    Text(String(format: "%.3f", Double(valor2)))
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .frame(width: 70)
                }
                .frame(width: 60)
                Spacer()
            }
            .frame(width: valor3, height: 240, alignment: .bottom)
        }
        .padding(20)
        .background(valor4)
        .cornerRadius(6)
    }
    
    func calcularDibujo(valor: CGFloat, valor2: CGFloat) -> (CGFloat, CGFloat) {
        
        var altura1 = CGFloat(0)
        var altura2 = CGFloat(0)
        
        var nuevoValor1 = valor
        var nuevoValor2 = valor2
        
        let temp = nuevoValor1 + nuevoValor2
        
        if temp > CGFloat(200){
            let tamanio = 200
            if(valor > valor2){
                nuevoValor1 = CGFloat(tamanio)
                altura2 = (nuevoValor2 * nuevoValor1) / valor
                altura1 = nuevoValor1
            } else{
                nuevoValor2 = CGFloat(tamanio)
                altura1 = (nuevoValor1 * nuevoValor2) / valor2
                altura2 = nuevoValor2
            }
            
            return (altura1, altura2)
        }
        else{
            if nuevoValor1 > 30{
                altura1 = nuevoValor1
                altura2 = nuevoValor2
            } else{
                altura1 = nuevoValor1 * 3
                altura2 = nuevoValor2 * 3
            }
            return (altura1, altura2)
     
       }
       */
}
/*
struct VerMasVista_Previews: PreviewProvider {
    static var previews: some View {
        //VerMasVista()
    }
}
*/
*/

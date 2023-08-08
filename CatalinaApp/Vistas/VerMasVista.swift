//
//  VerMasVista.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI
import CoreData

struct VerMasVista: View {
    
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
    
    var body: some View {
        
        ScrollView (showsIndicators: false) {
            Spacer().frame(height: 30)
            VStack {
                ForEach(objetosFiltrados, id: \.self) { objeto in
                    VStack(alignment: .leading) {
                        Text("Fecha: \(objeto.fecha ?? Date(), formatter: Self.fechaFormato)")
                            .font(.headline)
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
                        crearGrafico(valor0: "(TMS)",valor1: "Tratamiento", valor: CGFloat(vRMtratamiento), valor2: CGFloat(vRMtratamientoB), valor3: 250, valor4: coloresFondo[4], valor5: true)
                        Spacer().frame(height: 20)
                        Text("Plomo")
                            .font(.headline)
                        HStack{
                            crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor: CGFloat(vRMpl_prod), valor2: CGFloat(vRMpl_prodB), valor3: 125, valor4: coloresFondo[1], valor5: false)
                            crearGrafico(valor0: "(%Pb)",valor1: "Calidad", valor: CGFloat(vRMpl_ley), valor2: CGFloat(vRMpl_leyB), valor3: 125, valor4: coloresFondo[1], valor5: false)
                        }
                        HStack{
                            crearGrafico(valor0: "(%Pb)",valor1: "Recuperacion", valor: CGFloat(vRMpl_rec), valor2: CGFloat(vRMpl_recB), valor3: 125, valor4: coloresFondo[1], valor5: false)
                            crearGrafico(valor0: "(TMS)",valor1: "Finos", valor: CGFloat(vRMpl_finos), valor2: CGFloat(vRMpl_finosB), valor3: 125, valor4: coloresFondo[1], valor5: false)
                        }
                        Spacer().frame(height: 20)
                        Text("Zinc")
                            .font(.headline)
                        HStack{
                            crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor: CGFloat(vRMzn_prod), valor2: CGFloat(vRMzn_prodB), valor3: 125, valor4: coloresFondo[2], valor5: false)
                            crearGrafico(valor0: "(%Zn)",valor1: "Calidad", valor: CGFloat(vRMzn_ley), valor2: CGFloat(vRMzn_leyB), valor3: 125, valor4: coloresFondo[2], valor5: false)
                        }
                        HStack{
                            crearGrafico(valor0: "(%Zn)",valor1: "Recuperacion", valor: CGFloat(vRMzn_rec), valor2: CGFloat(vRMzn_recB), valor3: 125, valor4: coloresFondo[2], valor5: false)
                            crearGrafico(valor0: "(TMS)",valor1: "Finos", valor: CGFloat(vRMzn_finos), valor2: CGFloat(vRMzn_finosB), valor3: 125, valor4: coloresFondo[2], valor5: false)
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
    
    func crearGrafico(valor0: String, valor1: String, valor: CGFloat, valor2: CGFloat, valor3: CGFloat, valor4: Color, valor5: Bool) -> some View {

        let multiplicador = seMultiplica(valor: valor, valor2: valor2, valor3: false, valor4: 1)
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                VStack{
                    Text(valor1)
                        .font(.system(size: 15))
                        .bold()
                        .frame(width: 300)
                    Text(valor0)
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
                        if valor5{
                            let nuevonum = valorProporcional(valor: valor, valor1: valor2)
                            Rectangle()
                                .foregroundColor(.green)
                                .frame(width: 20, height: min(nuevonum, 200))
                                .cornerRadius(6)
                        } else{
                            Rectangle()
                                .foregroundColor(.green) // Cambia el color aquí
                                .frame(width: 20, height: min(calcularValor(valor: valor, multiplicador: multiplicador), 200))
                                .cornerRadius(6)
                        }
                        /*
                         if valor > valor2 {
                         Path { path in
                         path.move(to: CGPoint(x: 25, y: valor)) // Coordenadas de inicio (ajusta según tus necesidades)
                         path.addLine(to: CGPoint(x: 105, y: valor)) // Coordenadas de final (ajusta según tus necesidades)
                         }
                         .stroke(style: StrokeStyle(lineWidth: 2, dash: [5])) // Utiliza un patrón de línea punteada [5] ajustando el valor para controlar la longitud de los segmentos punteados
                         }
                         */
                    }
                    Text(String(format: "%.3f", Double(valor)))
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                }
                .frame(width: 60)
                VStack {
                    ZStack(alignment: .bottom) {
                        if valor5{
                            if valor > valor2{
                                let nuevonum2 = valorProporcional(valor: valor, valor1: valor2)
                                Rectangle()
                                    .foregroundColor(.green)
                                    .frame(width: 20, height: min(nuevonum2, 200))
                                    .cornerRadius(6)
                            }else{
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: min(calcularValor(valor: valor2, multiplicador: multiplicador), 200))
                                    .cornerRadius(6)
                            }
                        } else{
                            Rectangle()
                                .foregroundColor(.blue)
                                .frame(width: 20, height: min(calcularValor(valor: valor2, multiplicador: multiplicador), 200))
                                .cornerRadius(6)
                        }
                        /*
                        if 20 > diferencia1 {
                            Rectangle()
                                .foregroundColor(.blue) // Cambia el color aquí
                                .frame(width: 20, height: min(valor2 - 30, 200))
                                .cornerRadius(6)
                        } else{
                            Rectangle()
                                .foregroundColor(.blue) // Cambia el color aquí
                                .frame(width: 20, height: min(valor2, 200))
                                .cornerRadius(6)
                        }
                         */
                    }
                    Text(String(format: "%.3f", Double(valor2)))
                        .foregroundColor(.black)
                        .font(.system(size: 12))
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

    func seMultiplica(valor: CGFloat, valor2: CGFloat, valor3: Bool, valor4: CGFloat) -> CGFloat{
        if valor <= 70 && valor2 <= 70 {
            let multiplicador = obtenerMultiplicador(valor: valor, valor0: valor4)
            return multiplicador
        }
        return valor4
    }
    
    func obtenerMultiplicador(valor: CGFloat, valor0: CGFloat) -> CGFloat{
        if valor >= 0.000 && valor <= 6.000 {
            return valor0 * 14
        } else if valor > 6.000 && valor <= 10.000 {
            return valor0 * 7
        } else if valor > 10.000 && valor <= 15.000 {
            return valor0 * 4
        } else if valor > 15.000 && valor <= 50.000 {
            return valor0 * 2.3
        } else if valor > 50.000 && valor <= 70.000 {
            return valor0 * 2
        } else if valor > 50.000 && valor <= 95.000 {
            return valor0 * 1.2
        }
        else {
            let valor3 = 1
            return CGFloat(valor3)
        }
    }
    
    func calcularValor(valor: CGFloat, multiplicador: CGFloat) -> CGFloat {
        return valor * multiplicador
    }
    
    func valorProporcional(valor: CGFloat, valor1: CGFloat) -> CGFloat{
        
        var nuevoValor: CGFloat = 0
        var nuevoValor2: CGFloat = 0
        
        if valor1 > valor{
            nuevoValor = valor * 100 / valor1
            nuevoValor2 = 200 * nuevoValor / 100
        } else {
            nuevoValor = valor1 * 100 / valor
            nuevoValor2 = 200 * nuevoValor / 100
        }
        
        return CGFloat(nuevoValor2)
    }
    
}


struct VerMasVista_Previews: PreviewProvider {
    static var previews: some View {
        VerMasVista()
    }
}

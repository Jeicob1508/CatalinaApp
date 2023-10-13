//
//  VerMasVista.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI
import CoreData

struct MasInfoMes: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalState: GlobalState
    @State private var fechaSeleccionada: Date = Date()
    @State private var vRMpl_ley: Double = 0.000
    @State private var vRMpl_prod: Double = 0.000
    @State private var vRMpl_rec: Double = 0.000
    @State private var vRMpl_finos: Double = 0.000
    
    @State private var numEntrada: Double = 0.000
    
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
    
    @State private var num_alto: Double = 0.000
    
    @StateObject var viewModel = ReadViewModel()

    @State private var objectIdToFind: Int = 0
    @State private var framess = false
    
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
        return formato
    }()

    var body: some View {
        var formattedMonth: String {
            let fechaInfo = "\(globalState.fechaInfo)"
            let monthString = String(fechaInfo.prefix(2))
            let yearString = String(fechaInfo.suffix(4))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            
            if let month = dateFormatter.date(from: monthString) {
                dateFormatter.dateFormat = "MMMM"
                dateFormatter.locale = Locale(identifier: "es")
                return dateFormatter.string(from: month).capitalized
            } else {
                return ""
            }
        }
        
        var fechaanio: String {
            let fechaInfo = "\(globalState.fechaInfo)"
            let yearString = String(fechaInfo.suffix(4))
            return yearString
        }
        
        VStack {
            Spacer().frame(height: 20)
            Text("\(formattedMonth) del \(fechaanio)") // Mostrar el mes en el título
                .font(.title)
            
            if !viewModel.listObject_Budget.isEmpty {
                VStack{
                    ForEach(viewModel.listObject_Budget, id: \.self) { object in
                        HStack{
                            Text("Tratamiento: ")
                            Text(String(object.tratamiento))
                        }
                    }
                }
            } else{
                Text("No hay nada")
            }
        }.onAppear {
            viewModel.findObject(objectIdToFind: globalState.fechaInfo)
        }
            /*
            if !viewModel.listObject_Budget.isEmpty {
                ForEach(viewModel.listObject_Budget, id: \.self) { object in
                    VStack{
                        vRMtratamientoB = object.tratamiento
                        vRMpl_prodB = object.PBProduccion
                        let vRMpl_leyB = object.PBCalidad
                        let vRMpl_recB = object.PBRecuperacion
                        let vRMpl_finosB = object.PBFinos
                        let vRMzn_prodB = object.ZNProduccion
                        let vRMzn_leyB = object.ZNCalidad
                        let vRMzn_recB = object.ZNRecuperacion
                        let vRMzn_finosB = object.ZNFinos
                    }
                }
            }
        }.onAppear {
            viewModel.findObject(objectIdToFind: globalState.fechaInfo)
        }
        */
        ScrollView (showsIndicators: false) {
            Spacer().frame(height: 30)
            VStack{
                
                crearGrafico(valor0: "(TMS)",valor1: "Tratamiento", valor: CGFloat(vRMtratamiento), valor2: CGFloat(vRMtratamientoB), valor3: 250, valor4: coloresFondo[4])
                    .transition(.move(edge: .top))
                Spacer().frame(height: 20)
                
                Rectangle()
                    .frame(height: 5)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.black : Color.white)
                
                Text("Plomo")
                    .font(.title2)
                HStack{
                    crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor: CGFloat(vRMpl_prod), valor2: CGFloat(vRMpl_prodB), valor3: 125, valor4: coloresFondo[1])
                    let temp = vRMpl_ley / numEntrada
                    crearGrafico(valor0: "(%Pb)",valor1: "Calidad", valor: CGFloat(temp), valor2: CGFloat(vRMpl_leyB), valor3: 125, valor4: coloresFondo[1])
                }
                HStack{
                    let temp2 = vRMpl_rec / numEntrada
                    crearGrafico(valor0: "(%Pb)",valor1: "Recuperación", valor: CGFloat(temp2), valor2: CGFloat(vRMpl_recB), valor3: 125, valor4: coloresFondo[1])
                    crearGrafico(valor0: "(TMS)",valor1: "Finos", valor: CGFloat(vRMpl_finos), valor2: CGFloat(vRMpl_finosB), valor3: 125, valor4: coloresFondo[1])
                }
                Spacer().frame(height: 20)
                
                
                Rectangle()
                    .frame(height: 5)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.black : Color.white)
                
                Text("Zinc")
                    .font(.title2)
                HStack{
                    crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor: CGFloat(vRMzn_prod), valor2: CGFloat(vRMzn_prodB), valor3: 125, valor4: coloresFondo[2])
                    let temp3 = vRMzn_ley / numEntrada
                    crearGrafico(valor0: "(%Zn)",valor1: "Calidad", valor: CGFloat(temp3), valor2: CGFloat(vRMzn_leyB), valor3: 125, valor4: coloresFondo[2])
                }
                HStack{
                    let temp4 = vRMzn_rec / numEntrada
                    crearGrafico(valor0: "(%Zn)",valor1: "Recuperación", valor: CGFloat(temp4), valor2: CGFloat(vRMzn_recB), valor3: 125, valor4: coloresFondo[2])
                    crearGrafico(valor0: "(TMS)",valor1: "Finos", valor: CGFloat(vRMzn_finos), valor2: CGFloat(vRMzn_finosB), valor3: 125, valor4: coloresFondo[2])
                }
                Button(action: {
                    globalState.verMasVista2 = false
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
    
    func crearGrafico(valor0: String, valor1: String, valor: CGFloat, valor2: CGFloat, valor3: CGFloat, valor4: Color) -> some View {
        
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
                            .animation(.easeInOut(duration: 0.8), value: alturas.0)
                            .foregroundColor(.green)
                            .frame(width: 20, height: max(10, alturas.0))
                            .cornerRadius(6)
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
                            .animation(.easeInOut(duration: 0.8), value: alturas.1)
                            .foregroundColor(.blue)
                            .frame(width: 20, height: max(10, alturas.1))
                            .cornerRadius(6)
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
    }
}

struct CustomObject {
    var property1: String
    var property2: Int
}

struct VerMasVista2_Previews: PreviewProvider {
    static var previews: some View {
        MasInfoMes()
    }
}

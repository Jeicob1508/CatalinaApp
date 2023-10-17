//
//  MasInfoDiario.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 15/10/23.
//

import SwiftUI

struct MasInfoDiario: View {
    
    @State private var coloresoscuros: Int = 0
    @State private var mantenimientovar: Double = 0
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalState: GlobalState
    @StateObject var viewModel = ReadViewModel()
    
    let coloresFondo: [Color] = [
        Color(red: 206/255, green: 226/255, blue: 227/255), // Azul claro pastel
        Color(red: 241/255, green: 241/255, blue: 241/255), // Lila pastel
        Color(red: 247/255, green: 229/255, blue: 200/255), // Amarillo pastel
        Color(red: 243/255, green: 195/255, blue: 195/255), // Color Budget
        Color(red: 250/255, green: 214/255, blue: 214/255), // Rojo pastel
        
        Color(red: 60/255, green: 90/255, blue: 91/255), // Azul oscuro pastel
        Color(red: 100/255, green: 100/255, blue: 100/255), // Morado oscuro pastel
        Color(red: 140/255, green: 120/255, blue: 90/255), // Amarillo oscuro pastel
        Color(red: 100/255, green: 50/255, blue: 50/255), // Color oscuro Budget
        Color(red: 100/255, green: 40/255, blue: 40/255) // Rojo oscuro pastel
    ]
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            
            let fechaBudget = Int((globalState.TuplaBudgetD.0 % 1000000))
            if !viewModel.listObject_Budget.isEmpty{
                if let object = viewModel.listObject_Budget.first(where: { $0.id == fechaBudget }) {
                    HStack{
                        Spacer()
                        Text("Fecha: \(globalState.fechaInfoD)")
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                    Spacer().frame(height: 30)
                    if globalState.TuplaBudgetD.14 == 1 {
                        VStack{
                            Spacer()
                            Text("Día de Mantenimiento")
                                .font(.title)
                                .padding()
                            Spacer() .frame(height: 30)
                            Image(systemName: "wrench")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    } else {
                        VStack{
                            let temp0 = (globalState.TuplaBudget.1 / mantenimientovar)
                            crearGrafico(valor0: "(TMS)", valor1: "Tratamiento", valor:(globalState.TuplaBudgetD.1), valor2:(temp0), valor3: 250, valor4: coloresFondo[4 + coloresoscuros])
                                .transition(.move(edge: .top))
                            Spacer().frame(height: 20)
                            
                            Rectangle()
                                .frame(height: 5)
                                .frame(maxWidth: .infinity)
                                .background(colorScheme == .light ? Color.black : Color.white)
                            Text("Plomo")
                                .font(.title2)
                            let temp1 = (globalState.TuplaBudget.4 / mantenimientovar)
                            let temp2 = (globalState.TuplaBudget.10 / mantenimientovar)
                            HStack{
                                crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor: CGFloat(globalState.TuplaBudgetD.4), valor2: CGFloat(temp1), valor3: 125, valor4: coloresFondo[1 + coloresoscuros])
                                crearGrafico(valor0: "(%Pb)",valor1: "Calidad", valor: CGFloat(globalState.TuplaBudgetD.5), valor2:
                                                CGFloat(globalState.TuplaBudget.5), valor3: 125, valor4: coloresFondo[1 + coloresoscuros])
                            }
                            HStack{
                                crearGrafico(valor0: "(%Pb)",valor1: "Recuperación", valor: CGFloat(globalState.TuplaBudgetD.6), valor2:
                                                CGFloat(globalState.TuplaBudget.6), valor3: 125, valor4: coloresFondo[1 + coloresoscuros])
                                crearGrafico(valor0: "(TMS)",valor1: "Finos", valor: CGFloat(globalState.TuplaBudgetD.10), valor2:
                                                CGFloat(temp2), valor3: 125, valor4: coloresFondo[1 + coloresoscuros])
                            }
                            Spacer().frame(height: 20)
                            Rectangle()
                                .frame(height: 5)
                                .frame(maxWidth: .infinity)
                                .background(colorScheme == .light ? Color.black : Color.white)
                            Text("Zinc")
                                .font(.title2)
                            let temp3 = (globalState.TuplaBudget.7 / mantenimientovar)
                            let temp4 = (globalState.TuplaBudget.11 / mantenimientovar)
                            HStack{
                                crearGrafico(valor0: "(TMS)",valor1: "Produccion", valor: CGFloat(globalState.TuplaBudgetD.7), valor2: CGFloat(temp3), valor3: 125, valor4: coloresFondo[2 + coloresoscuros])
                                crearGrafico(valor0: "(%Zn)",valor1: "Calidad", valor: CGFloat(globalState.TuplaBudgetD.8), valor2:
                                                CGFloat(globalState.TuplaBudget.8), valor3: 125, valor4: coloresFondo[2 + coloresoscuros])
                            }
                            HStack{
                                crearGrafico(valor0: "(%Zn)",valor1: "Recuperación", valor: CGFloat(globalState.TuplaBudgetD.9), valor2:
                                                CGFloat(globalState.TuplaBudget.9), valor3: 125, valor4: coloresFondo[2 + coloresoscuros])
                                crearGrafico(valor0: "(TMS)",valor1: "Finos", valor: CGFloat(globalState.TuplaBudgetD.11), valor2:
                                                CGFloat(temp4), valor3: 125, valor4: coloresFondo[2 + coloresoscuros])
                            }
                            Button(action: {
                                globalState.ToggleDiario = false
                            }) {
                                Text("Cerrar")
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }.onAppear{
                            globalState.TuplaBudget = (object.id, object.tratamiento, object.varLeyPB,
                                                       object.varLeyZN, object.PBProduccion, object.PBCalidad,
                                                       object.PBRecuperacion, object.ZNProduccion, object.ZNCalidad,
                                                       object.ZNRecuperacion, object.PBFinos, object.ZNFinos,
                                                       object.PBHead, object.ZNHead, object.Mantenimiento )
                            if globalState.TuplaBudget.14 == 1 {
                                mantenimientovar = 29
                            } else {
                                mantenimientovar = 30
                            }
                        }
                    }
                } else {
                    Text("No hay Budget disponible")
                    Text("Fecha: \(String(fechaBudget))")
                }
                
            }
        }
        .onAppear {
            viewModel.observeListObjects()
            
            if colorScheme == .dark {
                coloresoscuros = 5
            } else {
                coloresoscuros = 0
            }
            
        }
    }
    
    func crearGrafico(valor0: String, valor1: String, valor: CGFloat, valor2: CGFloat, valor3: CGFloat, valor4: Color) -> some View {
        
        var simbolo = 0
        
        if valor > valor2 {
            simbolo = 1
        } else if valor2 > valor {
            simbolo = 2
        }
        
        let alturas = calcularDibujo(valor: valor, valor2: valor2)
        
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
                        .font(.system(size: 12))
                        .frame(width: 70)
                }
                .frame(width: 60)
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        switch simbolo{
                        case 0:
                            Image(systemName: "equal.circle")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                        case 1:
                            Image(systemName: "greaterthan.circle")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        case 2:
                            Image(systemName: "lessthan.circle")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        default:
                            Image(systemName: "questionmark.circle")
                                .font(.largeTitle)
                        }
                        Spacer()
                    }
                    Spacer()
                }.frame(width: 20)
                VStack {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .animation(.easeInOut(duration: 0.8), value: alturas.1)
                            .foregroundColor(.blue)
                            .frame(width: 20, height: max(10, alturas.1))
                            .cornerRadius(6)
                    }
                    Text(String(format: "%.3f", Double(valor2)))
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
        
        if nuevoValor1 > CGFloat(120) || nuevoValor2 > CGFloat(120) {
            let tamanio = 190
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
            if nuevoValor1 > 30 || nuevoValor2 > 30 {
                altura1 = nuevoValor1 * 1.15
                altura2 = nuevoValor2 * 1.15
            } else {
                altura1 = nuevoValor1 * 3.4
                altura2 = nuevoValor2 * 3.4
            }
            return (altura1, altura2)
        }
    }
}

#Preview {
    MasInfoDiario()
}

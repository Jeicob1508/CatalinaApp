//
//  ConfigNombre.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct ConfigNombre: View {
    @State private var txtfielnn: String = ""
    @State private var txtfielaa: String = ""
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        VStack{
            Spacer()
            Text("Actualice sus datos:")
                .padding(.leading, 20)
                .multilineTextAlignment(.leading)
            Spacer()
            TextField("Nombre", text:self.$txtfielnn)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(maxWidth: 170)
                .padding()
            TextField("Apellido", text:self.$txtfielaa)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(maxWidth: 170)
                .padding()
            Spacer()
            Button(action:{
                withAnimation {
                    globalState.configNA.toggle()
                }
            }){
                Text("Cerrar")
            }// Se puede poner la funcion de disabled para la DB y los usuarios
            Spacer()
            Button(action:{
                globalState.nombrePer = txtfielnn
                globalState.apellidoPer = txtfielaa
                withAnimation {
                    globalState.configNA.toggle()
                }
            }){
                Text("Guardar")
            }// Se puede poner la funcion de disabled para la DB y los usuarios
            Spacer()
        }
        .analyticsScreen(name: "\(ConfigNombre.self)")
    }
}

struct ConfigNombre_Previews: PreviewProvider {
    static var previews: some View {
        ConfigNombre()
    }
}

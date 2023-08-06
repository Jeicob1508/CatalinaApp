//
//  AgregarInformacion.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 4/08/23.
//

import SwiftUI

struct AgregarInformacion: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @State private var txtfieldL: String = ""
    @State private var txtfieldP: String = ""
    @State private var txtfieldR: String = ""
    @State private var suma: Double = 0.000
    
    @State private var varpl_ley: Double = 0.000
    @State private var varpl_prod: Double = 0.000
    @State private var varpl_rec: Double = 0.000
    @State private var vartratamiento: Double = 0.000
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Plomo Produccion:")
                    .padding(.leading, 20)
                    .multilineTextAlignment(.leading)
                Spacer()
                TextField("", text:self.$txtfieldP)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: 170)
                    .padding()
            }
            HStack{
                Text("Plomo Ley:")
                    .padding(.leading, 20)
                    .multilineTextAlignment(.leading)
                Spacer()
                TextField("", text:self.$txtfieldL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: 170)
                    .padding()
            }
            HStack{
                Text("Plomo Recuperado:")
                    .padding(.leading, 20)
                    .multilineTextAlignment(.leading)
                Spacer()
                TextField("", text:self.$txtfieldR)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: 170)
                    .padding()
            }
            Spacer()
            Button(action:{
                varpl_prod = Double(txtfieldP) ?? 0.000
                varpl_ley = Double(txtfieldL) ?? 0.000
                varpl_rec = Double(txtfieldR) ?? 0.000
                
                suma = varpl_prod + varpl_ley + varpl_rec
                
                vartratamiento = suma
                
                let agregar = CatalinaDB(context: self.moc)
                agregar.pl_prod = self.varpl_prod
                agregar.pl_ley = self.varpl_ley
                agregar.pl_rec = self.varpl_rec
                agregar.tratamiento = self.vartratamiento
                agregar.fecha = Date()
                agregar.id = UUID()
            }){
                Text("Agregar")
            }// Se puede poner la funcion de disabled para la DB y los usuarios
        }
    }
}

struct AgregarInformacion_Previews: PreviewProvider {
    static var previews: some View {
        AgregarInformacion()
    }
}

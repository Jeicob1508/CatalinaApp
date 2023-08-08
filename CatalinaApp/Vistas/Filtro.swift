//
//  Filtro.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

struct Filtro: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        VStack{
            Text("Vista del filtro")
            Button(action:{
                globalState.filtroview.toggle()
            }){
                Text("Cerrar")
            }
        }
        .onAppear{
            print(globalState.filtroview.description)
        }
    }
}

struct Filtro_Previews: PreviewProvider {
    static var previews: some View {
        Filtro()
    }
}

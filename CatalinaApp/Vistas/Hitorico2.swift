//
//  Hitorico2.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

struct Historico2: View {
    @StateObject private var globalState = GlobalState()
    
    var body: some View {
        HistoricoEx()
            .environmentObject(globalState)
    }
}

struct HistoricoEx: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    @State var selectedTab: Tabs = .historico
    
    
    var body: some View {
        ZStack{
            VStack{
                HistoricoView()
                    .environmentObject(globalState)
                    .environment(\.managedObjectContext, self.moc)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.all)
                /*
                Button(action:{
                    globalState.filtroview.toggle()
                }){
                    Text("Filtro")
                }
                .frame(height: 25)
                */
            }
            if globalState.filtroview{
                Filtro()
                    .environmentObject(globalState)
                    .environment(\.managedObjectContext, self.moc)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
            }
            if globalState.verMasVista{
                VerMasVista()
                    .environmentObject(globalState)
                    .environment(\.managedObjectContext, self.moc)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
            }
            if globalState.verMasVista2{
                VerMasVista2()
                    .environmentObject(globalState)
                    .environment(\.managedObjectContext, self.moc)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            globalState.filtroview = false
            globalState.verMasVista = false
            globalState.verMasVista2 = false
        }
    }
}

struct Historico2_Previews: PreviewProvider {
    static var previews: some View {
        Historico2()
    }
}


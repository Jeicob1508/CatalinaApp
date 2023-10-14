//
//  Hitorico2.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

struct MainMes: View {
    @StateObject private var globalState = GlobalState()
    
    var body: some View {
        HistoricoEx()
            .environmentObject(globalState)
    }
}

struct HistoricoEx: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab: Tabs = .historico
    
    var body: some View {
        ZStack{
            VStack{
                if globalState.ToggleMes{
                    MasInfoMes()
                        .environmentObject(globalState)
                        .environment(\.managedObjectContext, self.moc)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(colorScheme == .light ? Color.white : Color.black)
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                } else {
                    VistaMes()
                        .environmentObject(globalState)
                        .environment(\.managedObjectContext, self.moc)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(1)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        .onAppear{
                globalState.filtroview = false
                globalState.ToggleMes = false
                globalState.ToggleDiario = false
        }
    }
}

struct Historico2_Previews: PreviewProvider {
    static var previews: some View {
        MainMes()
    }
}


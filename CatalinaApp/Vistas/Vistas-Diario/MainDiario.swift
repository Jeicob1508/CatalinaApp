//
//  Hitorico2.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

struct MainDiario: View {
    @StateObject private var globalState = GlobalState()
    
    var body: some View {
        HistoricoEx2()
            .environmentObject(globalState)
    }
}

struct HistoricoEx2: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab: Tabs = .historico1
    
    
    var body: some View {
        ZStack{
            VStack{
                VistaDiario()
                    .environmentObject(globalState)
                    .environment(\.managedObjectContext, self.moc)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.all)
            }
            if globalState.ToggleDiario{
                MasInfoDiario()
                    .environmentObject(globalState)
                    .environment(\.managedObjectContext, self.moc)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
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

struct Historico3_Previews: PreviewProvider {
    static var previews: some View {
        MainDiario()
    }
}


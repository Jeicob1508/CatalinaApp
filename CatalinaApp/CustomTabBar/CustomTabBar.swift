//
//  CustomTabBar.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

enum Tabs: Int{
    case historico = 0
    case historico1 = 1
    case config = 2
}

struct CustomTabBar: View {
    
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var globalState: GlobalState
    @Binding var selectedTab: Tabs
    @State private var isShowingPopUp = false
    
    var body: some View {
        
        HStack (alignment: .center){
            
            Button {
                selectedTab = .historico
                globalState.verMasVista = false
                globalState.filtroview = false
            } label: {
                TabBarButton(buttonText: "Mensual", imageName: "calendar", isActive: selectedTab == .historico, imageBigger: true)
            }
            Button {
                selectedTab = .historico1
                globalState.verMasVista = false
                globalState.filtroview = false
            } label: {
                TabBarButton(buttonText: "Diario", imageName: "doc.plaintext", isActive: selectedTab == .historico1, imageBigger: true)
            }
            //Agregar el archivo
            //.tint(Color("icons-secundary"))
            if globalState.esAdmin {
                Button {
                    isShowingPopUp = true
                } label: {
                    GeometryReader { geo in
                        VStack (alignment: .center, spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Nuevo")
                        }
                        
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .sheet(isPresented: $isShowingPopUp, content:{
                        AgregarInformacion(isShowingPopUp: $isShowingPopUp)
                            .environment(\.managedObjectContext, self.moc)
                    })
                }
            }
            Spacer()
            Button {
                selectedTab = .config
            } label: {
                TabBarButton(buttonText: globalState.esAdmin ? "Config" : "Configuracion", imageName: "gear", isActive: selectedTab == .config, imageBigger: true)
            }
            
        }
        .frame(height: 82)
        
    }
    
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.historico))
    }
}
